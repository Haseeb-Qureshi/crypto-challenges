require 'openssl'
require 'securerandom'
require_relative 'padding'
require_relative 'binary'

class AES
  BLOCK_SIZE = 128 # bits

  def self.ecb_encrypt(key, msg, padding = nil)
    msg = msg.pack('c*') if msg.is_a?(Array)
    msg = padding.pad(msg).flatten.pack('c*') if padding

    cipher = OpenSSL::Cipher::Cipher.new('AES-128-ECB')
    cipher.encrypt
    cipher.padding = 0
    cipher.key = key
    cipher.update(msg) << cipher.final
  end

  def self.ecb_decrypt(key, ciphertext, padding = nil)
    ciphertext = ciphertext.pack('c*') if ciphertext.is_a?(Array)

    cipher = OpenSSL::Cipher::Cipher.new('AES-128-ECB')
    cipher.decrypt
    cipher.padding = 0
    cipher.key = key
    plaintext = cipher.update(ciphertext) << cipher.final
    padding ? padding.unpad(plaintext) : plaintext
  end

  def self.cbc_encrypt(key, msg)
    # choose IV
    iv = random_block(bits: BLOCK_SIZE)
    blocks = PCKS7.pad(msg, BLOCK_SIZE / 8)

    # prepend IV to ciphertext
    encrypted_blocks = [iv]

    # encrypt first block XORed with encrypted IV
    to_encrypt = pairwise_xor(iv.bytes, blocks.first)
    first_block = ecb_encrypt(key, to_encrypt)
    encrypted_blocks << first_block

    blocks[1..-1].each do |block|
      # xor each block with previous ciphertext, then encrypt
      to_encrypt = pairwise_xor(encrypted_blocks.last.bytes, block)
      encrypted_blocks << ecb_encrypt(key, to_encrypt)
    end

    encrypted_blocks.join
  end

  def self.cbc_decrypt(key, ciphertext)
    # decrypt first block
    blocks = ciphertext.bytes.each_slice(16).to_a
    iv = blocks.shift

    unencrypted_blocks = []
    first_block = blocks.first
    partial_decryption = ecb_decrypt(key, first_block)
    first_decrypted_block = pairwise_xor(iv, partial_decryption.bytes)
    unencrypted_blocks << first_decrypted_block

    blocks.each_with_index do |block, i|
      next if i == 0 # skip first block
      # decrypt second block
      partial_decryption = ecb_decrypt(key, block)
      # xor with first ciphertext block
      next_block = pairwise_xor(blocks[i - 1], partial_decryption.bytes)
      unencrypted_blocks << next_block
    end

    PCKS7.unpad(unencrypted_blocks.map { |b| b.pack('c*') }.join)
  end

  def self.ctr_encrypt(key, msg)
    # choose iv
    iv = random_block(bits: BLOCK_SIZE)

    blocks = msg.bytes.each_slice(16).to_a
    # prepend iv to ciphertext
    encrypted_blocks = [iv.dup]


    blocks.each_with_index do |block|
      encrypted_iv = ecb_encrypt(key, iv)
      encrypted_blocks << pairwise_xor(encrypted_iv.bytes, block).pack('c*')

      increment(iv)
    end

    encrypted_blocks.join
  end

  def self.ctr_decrypt(key, ciphertext)
    blocks = ciphertext.bytes.each_slice(16).to_a
    iv = blocks.shift.pack('c*')

    unencrypted_blocks = []

    blocks.each_with_index do |block|
      encrypted_iv = ecb_encrypt(key, iv)
      unencrypted_blocks << pairwise_xor(encrypted_iv.bytes, block).pack('c*')

      increment(iv)
    end

    unencrypted_blocks.join
  end

  def self.random_key(bytes = 16)
    SecureRandom.random_bytes(bytes)
  end

  def self.increment(iv)
    (iv.length - 1).downto(0) do |i|
      if iv[i].ord < 255
        iv[i] = iv[i].ord.next.chr
        return
      else
        iv[i] = 0.chr
      end
    end
  end
end

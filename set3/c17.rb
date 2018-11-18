# This is the best-known attack on modern block-cipher cryptography.
#
# Combine your padding code and your CBC code to write two functions.
# The first function should select at random one of the 10 strings and generate a random AES key (which it should save for all future encryptions), pad the string out to the 16-byte AES block size and CBC-encrypt it under that key, providing the caller the ciphertext and IV.
#
# The second function should consume the ciphertext produced by the first function, decrypt it, check its padding, and return true or false depending on whether the padding is valid.
#
# It turns out that it's possible to decrypt the ciphertexts provided by the first function.
#
# The decryption here depends on a side-channel leak by the decryption function. The leak is the error message that the padding is valid or not.
#
# You can find 100 web pages on how this attack works, so I won't re-explain it. What I'll say is this:
#
# The fundamental insight behind this attack is that the byte 01h is valid padding, and occur in 1/256 trials of "randomized" plaintexts produced by decrypting a tampered ciphertext.
#
# 02h in isolation is not valid padding.
#
# 02h 02h is valid padding, but is much less likely to occur randomly than 01h.
#
# 03h 03h 03h is even less likely.
#
# So you can assume that if you corrupt a decryption AND it had valid padding, you know what that padding byte is.

require_relative '../helpers/aes'
require_relative '../helpers/padding'
require_relative '../helpers/binary'
require 'base64'

STRINGS_C17 = File.readlines(__dir__ + '/c17_testfile.txt')
                  .map(&Base64.method(:decode64))
KEY_C17 = AES.random_key

def encrypt_random_string
  s = STRINGS_C17.sample
  AES.cbc_encrypt(KEY_C17, s)
end

def valid_padding?(ciphertext)
  begin
    AES.cbc_decrypt(KEY_C17, ciphertext)
    true
  rescue PCKS7::InvalidPaddingError => e
    false
  end
end

def decrypt_random_string(s = encrypt_random_string)
  decrypted = ""
  reconstructed_str = s

  (num_blocks(s) - 1).times do
    b = num_blocks(s)
    second_to_last_block = get_block(s, b - 1)
    16.times do |i|
      byte_to_change = -1 - i
      256.times do
        increment_byte!(second_to_last_block, byte_to_change)
        reconstructed_str = swap_block_at_idx(second_to_last_block, s, b - 2)
        break if valid_padding?(reconstructed_str)
      end

      # x ^ D(c3) == 0x01
      # D(c3) == 0x01 ^ x
      # real_val == c2 ^ D(c3)
      # c2[-1] ^ 0x01 ^ x  == real_val
      x = second_to_last_block[byte_to_change].ord
      real_val = get_block(s, b - 1)[byte_to_change].ord ^ (i + 1) ^ x
      decrypted.prepend(real_val.chr)

      (i + 1).times do |j| # set the last i + 1 bytes to i + 1
        idx = -1 - j
        second_to_last_block[idx] = ((i + 2) ^ (i + 1) ^ second_to_last_block[idx].ord).chr
      end
    end

    s = s[0...(16 * (b - 1))] # lop off a block and continue
  end
  PCKS7.unpad(decrypted)
end

def test
  random_string = encrypt_random_string
  decrypt_random_string(random_string) == AES.cbc_decrypt(KEY_C17, random_string)
end

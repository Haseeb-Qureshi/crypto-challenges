require 'faraday'
require 'digest'
require_relative '../helpers/aes'
require_relative '../helpers/padding'
require_relative '../helpers/binary'
require_relative '../base/hex'

URL = "http://crypto-class.appspot.com/po"
CIPHERTEXT = "f20bdba6ff29eed7b046d1df9fb7000058b1ffb4210a580f748b4ac714c001bd4a61044426fb515dad3f21f18aa577c0bdf302936266926ff37dbf7035d5eeb4"

def is_valid_pad?(ciphertext)
  hex = ciphertext.unpack("H*").first
  status = Faraday.get(URL, er: hex).status
  status == 404
end

def decrypt_ciphertext(s)
  s = Hex.to_ascii(s)
  decrypted = ""
  puts "Decrypting...!"
  reconstructed_str = s

  (num_blocks(s) - 1).times do
    b = num_blocks(s)
    second_to_last_block = get_block(s, b - 1)
    16.times do |i|
      byte_to_change = -1 - i
      256.times do
        increment_byte!(second_to_last_block, byte_to_change)
        reconstructed_str = swap_block_at_idx(second_to_last_block, s, b - 2)
        break if is_valid_pad?(reconstructed_str)
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
      p decrypted
    end

    s = s[0...(16 * (b - 1))] # lop off a block and continue
  end
  PCKS7.unpad(decrypted)
end

p decrypt_ciphertext(CIPHERTEXT)

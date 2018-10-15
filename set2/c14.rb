# Take your oracle function from #12. Now generate a random count of random bytes and prepend this string to every plaintext. You are now doing:
#
# AES-128-ECB(random-prefix || attacker-controlled || target-bytes, random-key)
# Same goal: decrypt the target-bytes.

require 'base64'
require 'securerandom'
require_relative '../helpers/aes'
require_relative '../helpers/padding'
require_relative '../helpers/binary'

def oracle(str)
  @super_secret_key ||= AES.random_key
  @unknown_str ||= Base64.decode64(File.read(__dir__ + '/c12_testfile.txt'))
  @random_bytes ||= SecureRandom.random_bytes(rand(16))
  AES.ecb_encrypt(@super_secret_key, @random_bytes + str + @unknown_str, PCKS7)
end

def break_secret_str
  block_size = AES.detect_block_size { |x| oracle(x) }
  raise 'damn' unless AES.is_ecb?(block_size) { |x| oracle(x) }
  raise 'wtf' unless block_size == 16

  all_chars = (32..126).map(&:chr)

  # <--random_prefix--><--------payload--------><target>

  feeder_byte = 19.chr
  input = feeder_byte * 32
  all_feeders_block = get_block(oracle(input), 2)

  length_of_prefix = nil
  31.downto(1) do |size|
    second_block = get_block(oracle(feeder_byte * size), 2)
    if second_block != all_feeders_block
      # now we've entered the second block
      # we now know the input to the first two bytes:
      # { prefix } + { x_bytes_first_block + 15 bytes in the second block }
      # size = bytes_in_first_block + 15
      length_of_prefix = 16 - (size - 15)
      break
    end
  end

  # now do the standard breakage attack
  mask_size = 16 + (16 - length_of_prefix)
  mask = feeder_byte * mask_size
  secret_str = ""

  block_size.times do
    # chop off the last character
    mask.chop!

    # get the ecb code including the next byte of the plaintext
    correct_val = get_block(oracle(mask), 2)

    # try all suffixes to see what produces the same ecb code
    all_chars.each do |char|
      if get_block(oracle(mask + secret_str + char), 2) == correct_val
        secret_str << char
        break
      end
    end
  end

  secret_str
end

def test
  break_secret_str == "Rollin' in my 5."
end

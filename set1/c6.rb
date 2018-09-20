require_relative '../helpers/hamming'
require_relative '../ciphers/character_xor'
require_relative '../base/ascii'
require_relative '../base/b64'
require_relative '../base/hex'
require 'base64'
require 'pry'

KEY_SIZE_GUESSES = (2..40)

def break_repeating_key_xor
  input = Base64.decode64(File.read(__dir__ + "/c6_testfile.txt"))
  key_size = compute_key_size(input)
  input_slices = divide_input_into_slices(input, key_size)
  key = input_slices.map { |slice| best_key(slice) }.join
  puts "Key: " + key
  puts "Decryption: " + repeating_decrypt(input, key)
end

def compute_key_size(input)
  KEY_SIZE_GUESSES.min_by do |guess|
    chunks = input.chars
                  .each_slice(guess)
                  .to_a[0..-2]
                  .map(&:join)
                  .each_cons(2)
    chunks.map { |chunk1, chunk2| edit_distance(chunk1, chunk2) }
          .reduce(:+)
          .fdiv(chunks.count)
          .fdiv(guess)
  end
end

def divide_input_into_slices(input, key_size)
  input.chars
       .group_by
       .with_index { |c, i| i % key_size }
       .values
       .map(&:join)
end

def repeating_decrypt(input, key)
  input.each_byte.with_index.reduce("") do |plaintext, (byte, i)|
    plaintext << (byte ^ key[i % key.length].ord).chr
  end
end

def test
  break_repeating_key_xor
end

# Base64 decode the string before appending it. Do not base64 decode the string by hand; make your code do it. The point is that you don't know its contents.
#
# What you have now is a function that produces:
#
# AES-128-ECB(your-string || unknown-string, random-key)
# It turns out: you can decrypt "unknown-string" with repeated calls to the oracle function!
#
# Here's roughly how:
#
# Feed identical bytes of your-string to the function 1 at a time --- start with 1 byte ("A"), then "AA", then "AAA" and so on. Discover the block size of the cipher. You know it, but do this step anyway.
# Detect that the function is using ECB. You already know, but do this step anyways.
# Knowing the block size, craft an input block that is exactly 1 byte short (for instance, if the block size is 8 bytes, make "AAAAAAA"). Think about what the oracle function is going to put in that last byte position.
# Make a dictionary of every possible last byte by feeding different strings to the oracle; for instance, "AAAAAAAA", "AAAAAAAB", "AAAAAAAC", remembering the first block of each invocation.
# Match the output of the one-byte-short input to one of the entries in your dictionary. You've now discovered the first byte of unknown-string.
# Repeat for the next byte.

require 'base64'
require_relative '../helpers/aes'
require_relative '../helpers/padding'
require 'pry'

ALL_CHARS = (32..126).map(&:chr)

def oracle(str)
  @super_secret_key ||= AES.random_key
  @unknown_str ||= Base64.decode64(File.read(__dir__ + '/c12_testfile.txt'))
  AES.ecb_encrypt(@super_secret_key, str + @unknown_str, PCKS7)
end

def detect_block_size
  initial_block_size = oracle("").length
  l = 1
  loop do
    subsequent_block_size = oracle(" " * l).length
    return subsequent_block_size - initial_block_size if subsequent_block_size > initial_block_size
    l += 1
  end
end

def is_ecb?(block_size = 16)
  plaintext = " " * (block_size * 3)
  ciphertext = oracle(plaintext)
  blocks = ciphertext.chars.each_slice(16).to_a
  blocks.uniq.length < blocks.length
end

def break_secret_str
  block_size = detect_block_size
  raise 'damn' unless is_ecb?(block_size)
  secret_str = ""
  mask = " " * block_size

  block_size.times do
    # chop off the last character
    mask.chop!

    # get the true value
    correct_val = oracle(mask)[0...block_size]

    # try all suffixes to see what produces the same ecb code
    ALL_CHARS.each do |char|
      if oracle(mask + secret_str + char)[0...block_size] == correct_val
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

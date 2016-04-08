require_relative '../helpers/hamming_distance'
require_relative '../helpers/base_conversions'

def challenge_6
  b64 = File.readlines("set1/c6_testfile.txt").map(&:chomp).join
  hex = b64_to_hex(b64)
end

def find_best_keysize(hex)
  (2..40).each do |key_size|

  end
end

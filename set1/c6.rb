require_relative '../helpers/hamming_distance'
require_relative '../helpers/base_conversions'

def challenge_6
  b64 = File.readlines("set1/c6_testfile.txt").map(&:chomp).join
  ascii = b64_to_ascii(b64)
  key_sizes = find_best_keysizes(ascii, 3)
  p key_sizes
end

def find_best_keysizes(ascii, n)
  bytes = ascii.chars
  key_size_scores = []
  num_slices = 4
  (2..40).each do |key_size|
    blocks = bytes.take(key_size * num_slices).each_slice(key_size).to_a
    key_size_scores << [key_size, score(blocks)]
  end
  key_size_scores.sort_by(&:first).take(3)
end

def score(blocks)
  total_distance = 0
  blocks.each_cons(2) do |b1, b2|
    total_distance += hamming_dist(b1.join, b2.join)
  end
  total_distance.fdiv(blocks.count)
end

def find_edit_distance(block1, block2)
  hamming_dist(block1.join, block2.join)
end

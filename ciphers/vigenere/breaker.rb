require_relative '../simple_xor/breaker'
require_relative '../simple_xor/cipher'
require_relative '../../helpers/hamming_distance'

class VigenereBreaker
  def initialize(ascii)
    @ciphertext = ascii
  end

  def break
    key = find_optimal_key
    XORCipher.new(@ciphertext, key).decrypt!
  end

  private

  def find_optimal_key
    key_sizes = find_best_keysizes(1)
    key_candidates = []
    key_sizes.each do |key_size|
      every_nth = every_nth_character(key_size)
      key_candidates << every_nth.map! { |block| best_xored_key(block) }.join
    end
    key_candidates.select(&:ascii_only?).first
  end

  def every_nth_character(key_size)
    @ciphertext.chars
               .group_by.with_index { |char, i| i % key_size }
               .values
               .map(&:join)
  end

  def find_best_keysizes(n)
    bytes = @ciphertext.chars
    key_size_scores = []
    num_slices = 30
    (2..40).each do |key_size|
      blocks = bytes.take(key_size * num_slices).each_slice(key_size).to_a
      key_size_scores << [key_size, score(blocks)]
    end
    key_size_scores.sort_by(&:last).take(n).map(&:first)
  end

  def score(blocks)
    total_distance = 0
    blocks.each_cons(2) do |b1, b2|
      total_distance += hamming_dist(b1.join, b2.join)
    end
    total_distance.fdiv(blocks.count).fdiv(blocks.first.length)
  end

  def find_edit_distance(block1, block2)
    hamming_dist(block1.join, block2.join)
  end
end

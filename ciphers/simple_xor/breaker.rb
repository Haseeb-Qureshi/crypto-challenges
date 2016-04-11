require_relative '../../helpers/base_conversions'

MOST_COMMON_LETTERS = "ETAOIN SHRLDU".chars
LETTER_SCORES = MOST_COMMON_LETTERS.zip((0..15).to_a.reverse).to_h
LETTER_SCORES.default = 0
LETTER_SCORES.freeze

def best_cipher_match(input)
  input = hex_to_ascii(input) if is_hex?(input)
  best_xored_string(input)
end

def best_xored_string(ascii)
  best_xored_match(ascii).first
end

def best_xored_key(ascii)
  best_xored_match(ascii).last.chr
end

def best_xored_match(ascii)
  max_str = ""
  max_key = 0
  max_score = 0
  256.times do |i|
    xored = xor_with(ascii, i)
    score = letter_score(xored)
    max_str, max_score, max_key = xored, score, i if score > max_score
  end
  [max_str, max_key]
end

def best_xored_strings(ascii)
  candidate_matches = {}

  256.times do |i|
    xored = xor_with(ascii, i)
    candidate_matches[xored] = letter_score(xored)
  end

  candidate_matches.sort_by(&:last).last(5).map(&:first).reverse
end

def xor_with(ascii, n)
  ascii.each_byte.inject("") { |str, byte| str << (byte ^ n).chr }
end

def letter_score(str)
  str.chars.inject(0) { |score, c| score + LETTER_SCORES[c.upcase] }
end

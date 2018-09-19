require_relative '../base/hex'
require_relative '../base/b64'

MOST_FREQUENT = 'ETAOIN SHRDLU'
POSSIBLE_KEYS = B64.alphabet

def best_key(input)
  POSSIBLE_KEYS.max_by { |key| key_score(input, key) }
end

def key_score(input, key)
  input.chars.each_slice(2).reduce(0) do |score, slice|
    val = Hex.new(slice.join).to_i
    decoded_char = (val ^ key.ord).chr
    score + (MOST_FREQUENT.reverse.index(decoded_char.upcase) || 0)
  end
end

def decoded_input(input, key)
  input.chars.each_slice(2).map do |slice|
    (Hex.new(slice.join).to_i ^ key.ord).chr
  end.join
end

require_relative '../base/hex'
require_relative '../base/b64'

MOST_FREQUENT = 'ETAOIN SHRDLU'.reverse
POSSIBLE_KEYS = (0..127).map(&:chr)

def best_key(input)
  POSSIBLE_KEYS.max_by { |key| key_score(input, key) }
end

def key_score(input, key)
  input.bytes.reduce(0) do |score, byte|
    decoded_char = (byte ^ key.ord).chr
    score + (MOST_FREQUENT.index(decoded_char.upcase) || 0)
  end
end

def decoded_input(input, key)
  input.bytes.map { |byte| byte ^ key.ord }.pack('c*')
end

require_relative '../base/hex'
require_relative '../base/b64'

MOST_FREQUENT = 'ETAOIN SHRDLU'.reverse
POSSIBLE_KEYS = [*'A'..'Z', *'a'..'z', *'0'..'9']

def best_key(input)
  POSSIBLE_KEYS.map { |key| [key, key_score(input, key)] }
               .sort_by(&:last)
               .tap { |keys| p keys.last(3) }
               .max_by(&:last)
               .first
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

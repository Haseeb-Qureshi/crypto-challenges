require_relative '../ciphers/character_xor'
require_relative '../base/hex'

def test
  inputs = File.readlines(__dir__ + '/c04_testfile.txt')
               .map(&:chomp)
               .map { |h| Hex.to_ascii(h) }

  inputs.lazy.map do |input|
    key = best_key(input)
    [key_score(input, key), decoded_input(input, key)]
  end.max_by(&:first).last == "Now that the party is jumping\n"
end

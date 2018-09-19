require_relative '../ciphers/character_xor'

def test
  inputs = File.readlines(__dir__ + '/c4_testfile.txt').map(&:chomp)

  inputs.lazy.map do |input|
    key = best_key(input)
    [key_score(input, key), decoded_input(input, key)]
  end.max_by(&:first).last == "Now that the party is jumping\n"
end

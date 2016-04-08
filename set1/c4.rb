require_relative '../ciphers/simple_xor/breaker'

def challenge_4
  all_strings = File.readlines('set1/c4_testfile.txt').map(&:chomp!)
  all_strings.map { |str| best_cipher_match(str) }
             .max_by { |str| letter_score(str) } == "Now that the party is jumping\n"
end

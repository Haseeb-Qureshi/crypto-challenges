require_relative 'xor_cipher_breaker'

def challenge_3
  input = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'
  best_cipher_match(input) == "Cooking MC's like a pound of bacon"
end

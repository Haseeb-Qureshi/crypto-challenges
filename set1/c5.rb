# Here is the opening stanza of an important work of the English language:
#
# Burning 'em, if you ain't quick and nimble
# I go crazy when I hear a cymbal
# Encrypt it, under the key "ICE", using repeating-key XOR.
require_relative '../base/ascii'
require_relative '../base/hex'

INPUT = "Burning 'em, if you ain't quick and nimble
I go crazy when I hear a cymbal"
KEY = "ICE"
EXPECTED_OUTPUT = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"

def repeating_encrypt(input, key)
  input.each_char.with_index.reduce("") do |encrypted, (char, i)|
    next_val = char.ord ^ key[i % key.length].ord
    encrypted << next_val.chr
  end
end

def test
  p Hex.from_ascii(repeating_encrypt(INPUT, KEY))
  Hex.from_ascii(repeating_encrypt(INPUT, KEY)) == EXPECTED_OUTPUT
end

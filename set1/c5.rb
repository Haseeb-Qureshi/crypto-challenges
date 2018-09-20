# Here is the opening stanza of an important work of the English language:
#
# Burning 'em, if you ain't quick and nimble
# I go crazy when I hear a cymbal
# Encrypt it, under the key "ICE", using repeating-key XOR.
require_relative '../base/ascii'
require_relative '../base/hex'

INPUT_C5 = "Burning 'em, if you ain't quick and nimble
I go crazy when I hear a cymbal"
KEY_C5 = "ICE"
EXPECTED_OUTPUT_C5 = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"

def repeating_encrypt(input, key)
  input.bytes.each_with_index.reduce([]) do |encrypted_bytes, (byte, i)|
    next_byte = byte ^ key[i % key.length].ord
    encrypted_bytes << next_byte
  end.pack('c*')
end

def test
  repeating_encrypt(INPUT_C5, KEY_C5).unpack('H*').first == EXPECTED_OUTPUT_C5
end

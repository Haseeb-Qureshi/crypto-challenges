INPUT = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
EXPECTED_OUTPUT = 'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t'

require_relative '../base/hex'
require_relative '../base/b64'

# Write a function that converts Hex to Base64
def convert_hex_to_b64
  Hex.new(INPUT).to(B64) == EXPECTED_OUTPUT
end

def test
  convert_hex_to_b64
end

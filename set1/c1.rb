require_relative '../base/hex'
require_relative '../base/b64'
require 'base64'

INPUT_C1 = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
EXPECTED_OUTPUT_C1 = 'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t'

# Write a function that converts Hex to Base64
def my_convert_hex_to_b64
  Hex.new(INPUT_C1).to(B64) == EXPECTED_OUTPUT_C1
end

def convert_hex_to_b64
  Base64.encode64(Hex.to_ascii(INPUT_C1)).delete("\n") == EXPECTED_OUTPUT_C1
end

def test
  convert_hex_to_b64
end

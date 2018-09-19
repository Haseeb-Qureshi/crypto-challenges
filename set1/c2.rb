# 1c0111001f010100061a024b53535009181c
# ... after hex decoding, and when XOR'd against:
#
# 686974207468652062756c6c277320657965
# ... should produce:
#
# 746865206b696420646f6e277420706c6179

INPUT1 = '1c0111001f010100061a024b53535009181c'
INPUT2 = '686974207468652062756c6c277320657965'
OUTPUT = '746865206b696420646f6e277420706c6179'

require_relative '../base/hex'

def fixed_xor
  Hex.new(Hex.new(INPUT1).to_i ^ Hex.new(INPUT2).to_i) == OUTPUT
end

def test
  fixed_xor
end

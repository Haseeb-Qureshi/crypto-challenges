# 1c0111001f010100061a024b53535009181c
# ... after hex decoding, and when XOR'd against:
#
# 686974207468652062756c6c277320657965
# ... should produce:
#
# 746865206b696420646f6e277420706c6179

INPUT1_C2 = '1c0111001f010100061a024b53535009181c'
INPUT2_C2 = '686974207468652062756c6c277320657965'
OUTPUT_C2 = '746865206b696420646f6e277420706c6179'

require_relative '../base/hex'

def my_fixed_xor
  Hex.new(Hex.new(INPUT1_C2).to_i ^ Hex.new(INPUT2_C2).to_i) == OUTPUT_C2
end

def fixed_xor
  input1 = Hex.to_bytes(INPUT1_C2)
  input2 = Hex.to_bytes(INPUT2_C2)
  input1.zip(input2).map { |a, b| a ^ b }.pack('c*').unpack("H*").first
end

def test
  fixed_xor == OUTPUT_C2
end

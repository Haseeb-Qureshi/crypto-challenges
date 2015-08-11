require 'byebug'

class Hex < String
  DICT = {}
  (0..9).each { |num| DICT[num] = num.to_s }
  ('a'..'f').each_with_index { |letter, i| DICT[i + 10] = letter }

  def self.dict
    DICT
  end

  def self.base
    16
  end

  def to_b64
    self.to_i.encode_in_base(B64)
  end

  def to_i
    dict = DICT.to_a.map(&:reverse).to_h

    chars.reverse.each_with_index.inject(0) do |num, (char, i)|
      num + (dict[char] * (16 ** i))
    end
  end

  def ^(other)
    (to_i ^ other.to_i).to_hex
  end
end

class B64 < String
  DICT = {}
  ('A'..'Z').each_with_index { |letter, i| DICT[i] = letter }
  ('a'..'z').each_with_index { |letter, i| DICT[i + 26] = letter }
  (0..9).each { |num| DICT[num + 52] = num.to_s }
  DICT[62] = "+"
  DICT[63] = "/"

  def self.dict
    DICT
  end

  def self.base
    64
  end

  def to_i
    dict = DICT.to_a.map(&:reverse).to_h

    chars.reverse.each_with_index.inject(0) do |num, (char, i)|
      num += (dict[char] * (64 ** i))
      num
    end
  end

  def to_hex
    self.to_i.encode_in_base(Hex)
  end

  def ^(other)
    (self.to_i ^ other.to_i).to_b64
  end
end

class Integer
  def to_hex
    Hex.new(encode_in_base(Hex))
  end

  def to_b64
    B64.new(encode_in_base(B64))
  end

  def encode_in_base(base_class)
    dict = base_class.dict
    base = base_class.base

    output = ""
    num = self
    num_digits = Math.log(num, base).ceil

    num_digits.times do |i|
      this_power = base ** (num_digits - i - 1)
      output += dict[num / this_power]
      num = num % this_power
    end

    base_class.new(output)
  end
end

=begin

Write a function that takes two equal-length buffers and produces their XOR combination.

If your function works properly, then when you feed it the string:

=end

Z = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"


A = "1c0111001f010100061a024b53535009181c"

B = "686974207468652062756c6c277320657965"

C = "746865206b696420646f6e277420706c6179"

#
# def find_match(input)
#   length = hex_to_b64(input).length
#   [('a'..'z'), ('B'..'Z')].each do |range|
#     range.each do |letter|
#       possible_match = letter * length
#       num = b64_to_num(possible_match)
#       xor = xor(num_to_hex(num), input)
#       p hex_to_b64(xor)
#     end
#   end
# end
#
# find_match(A)

def challenge_3
  input = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'
  p input.chars.each_slice(2).map { |slice| Hex.new(slice.join).to_i.chr }.join
  # h = Hash.new(0)
  # e, t, a, i, o, n = h.sort_by(&:last).reverse.map { |c, _| B64.num_from_char(c) }
  # xe, xt, xa, xi = "etai".chars.map { |c| B64.num_from_char(c) }
  # # e ^ t
  # p [e, t, xe, xt]
  # p e ^ xt
  # 128.times do |i|
  #   p b.each_codepoint.inject("") { |str, v| str << (v ^ i).chr }
  # end
  #
  #
  # # E => 3
  # # T => 7
  #
  # p Hex.new(input).to_b64
end

def challenge_3_binary
end

def hamming_dist(str1, str2)
  raise TypeError unless [str1, str2].all? { |el| el.is_a?(String) }

  n1, n2 = [str1, str2].map { |str| binary(str) }
  parity(n1 ^ n2)
end

def parity(n)
  par = 0
  until n == 0
    par += 1
    n &= n - 1
  end
  par
end

def binary(str)
  str.each_char.inject(0) do |binary, char|
    binary <<= 8
    binary |= char.ord
  end
end

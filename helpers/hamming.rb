def edit_distance(s1, s2)
  parity(to_binary(s1) ^ to_binary(s2))
end

def parity(num)
  par = 0
  while num > 0
    par += 1
    num &= num - 1
  end
  par
end

def to_binary(s)
  s.each_char.inject(0) do |val, char|
    val <<= 8
    val |= char.ord
  end
end

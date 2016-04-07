class Numeric
  def self.from_base(base, str)
    power = -1
    str.reverse.each_char.inject(0) do |num, char|
      power += 1
      num + base.reverse_dict[char] * base::BASE ** power
    end
  end

  def to(klass)
    to_other_base(klass)
  end

  def to_hex
    to_other_base(Hex)
  end

  def to_b64
    to_other_base(B64)
  end

  def xor(other)
    self ^ other.to_i
  end

  private

  def to_other_base(b)
    str = ""
    power = 0
    num = self
    until num == 0
      num, next_val = num.divmod(b::BASE)
      power += 1
      str << b.char(next_val) unless b.char(next_val).nil?
    end
    b.new(str.reverse)
  end
end

module BaseConvertable
  module ClassMethods
    def char(num)
      dict[num]
    end

    def num_from_char(char)
      reverse_dict[char]
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def to_hex
    to_i.to_hex
  end

  def to_b64
    to_i.to_b64
  end

  def ==(other)
    other.is_a?(String) ? to_s == other : to_i == other.to_i
  end

  def inspect
    "#{to_s}: #{to_i}"
  end

  def to_s
    String.new(self)
  end

  def to_i
    Numeric.from_base(self.class, self)
  end

  def xor(other)
    (to_i ^ other.to_i).to(self.class)
  end

  def each_codepoint
    return enum_for(:each_codepoint) unless block_given?
    
    each_char { |char| yield self.class.num_from_char(char) }
  end

  def map_each_codepoint!
    return enum_for(:map_each_codepoint!) unless block_given?

    length.times do |i|
      self[i] = self.class.char(yield self.class.num_from_char(self[i]))
    end
    self
  end
end

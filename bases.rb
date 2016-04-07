module Baseable
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
    length.times { |i| self[i] = self.class.char(yield self.class.num_from_char(self[i])) }
    self
  end
end

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

class Hex < String
  include Baseable
  BASE = 16
  def initialize(input)
    super(input.is_a?(Numeric) ? input.to_hex : input)
  end

  def xor(other)
    (to_i ^ other.to_i).to_hex
  end

  def self.dict
    @@dict ||= (0...16).zip(('0'..'9').to_a + ('a'..'f').to_a).to_h.freeze
  end

  def self.reverse_dict
    @@reverse_dict ||= dict.invert
  end
end

class B64 < String
  include Baseable
  BASE = 64
  def initialize(input)
    super(input.is_a?(Numeric) ? input.to_b64 : input)
  end

  private

  def self.dict
    @@dict ||= generate_dict
  end

  def self.reverse_dict
    @@reverse_dict = dict.invert
  end

  def self.generate_dict
    chars = ('A'..'Z').to_a +
            ('a'..'z').to_a +
            ('0'..'9').to_a +
            ['+', '/']
    (0...64).zip(chars).to_h.freeze
  end
end

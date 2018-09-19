class Base < String
  def initialize(*args)
    args[0] = self.class.to_self(args[0]) if args[0].is_a?(Numeric)
    super(*args)
  end

  def self.get_alphabet
    raise NotImplementedError
  end

  def self.alphabet
    @alphabet ||= get_alphabet
  end

  def self.values
    @values ||= alphabet.each_with_index.to_h
  end

  def self.base
    @base = alphabet.length
  end

  def self.to_self(int)
    raise "Not a fixnum: #{int}" unless int.is_a?(Numeric)
    return alphabet.first if int == 0
    largest_pow = Math.log(int, base).floor

    self.new.tap do |s|
      largest_pow.downto(0) do |pow|
        next_val, int = int.divmod(base ** pow)
        s << alphabet[next_val]
      end
    end
  end

  def to(klass)
    klass.new(to_i)
  end

  def to_i
    reverse.each_char.with_index.reduce(0) do |val, (char, i)|
      binding.pry if self.class.values[char].nil?
      val + self.class.values[char] * self.class.alphabet.length ** i
    end
  end
end

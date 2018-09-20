require_relative 'base'

class Hex < Base
  def self.from_ascii(s)
    s.chars.map do |char|
      Hex.to_self(char.ord >> 4) + Hex.to_self(char.ord & 0x0f)
    end.join
  end

  def self.get_alphabet
    [*'0'..'9', *'a'..'f']
  end

  def self.to_bytes(s)
    to_ascii(s).bytes.to_a
  end

  def self.to_ascii(s)
    [s].pack('H*')
  end
end

class Hex < String
  include BaseConvertable
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

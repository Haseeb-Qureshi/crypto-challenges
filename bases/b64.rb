class B64 < String
  include BaseConvertable
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

require_relative 'base'

class ASCII < Base
  def self.get_alphabet
    (0..255).map(&:chr)
  end
end

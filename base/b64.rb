require_relative 'base'

class B64 < Base
  def self.get_alphabet
    [*'A'..'Z', *'a'..'z', *'0'..'9', '+', '/']
  end
end

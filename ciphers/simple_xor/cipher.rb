class XORCipher
  def initialize(message, key)
    @msg = message
    @key = key
    @encrypted = false
  end

  def encrypt!
    @encrypted = true
    crypt!
  end

  def decrypt!
    @encrypted = false
    crypt!
  end

  def to_hex
    @msg.unpack("H*").first
  end

  private

  def crypt!
    @msg.length.times do |i|
      @msg[i] = (@msg[i].ord ^ wrapped_key(i)).chr
    end
    @msg
  end

  def wrapped_key(i)
    @key[i % @key.length].ord
  end
end

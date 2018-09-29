class PCKS7
  def self.pad(msg, size = 16)
    blocks = msg.bytes.each_slice(size).to_a

    if blocks.last.length == size
      blocks << ([size] * size)
    else
      padding = size - blocks.last.length
      blocks.last.concat([padding] * padding)
    end

    blocks
  end

  def self.unpad(msg, size = 16)
    bytes_of_padding = msg[-1].ord
    msg[0..-1 - bytes_of_padding]
  end
end

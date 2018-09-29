def pairwise_xor(i1, i2)
  i1, i2 = [i1, i2].map(&:bytes) if i1.is_a?(String)

  i1.zip(i2).select(&:all?).map { |a, b| a ^ b }
end

def all_ascii?(bytes)
  bytes.all? { |byte| byte.chr.ascii_only? }
end

def random_block(bits: 128)
  [rand(2 ** bits).to_s(16)].pack('H*').bytes.pack('c*')
end

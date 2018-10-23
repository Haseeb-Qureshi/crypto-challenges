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

def num_blocks(str, block_size = 16)
  str.length.fdiv(block_size).ceil
end

def get_block(str, n, block_size = 16)
  str[((n - 1) * block_size)...(((n - 1) * block_size) + block_size)]
end

def swap_block_at_idx(block, str, n, block_size = 16)
  raise "Invalid block num" if n >= num_blocks(str, block_size)

  str[0...(n * block_size)] + block + (str[((n + 1) * block_size)..-1] || "")
end

def increment_byte!(s, i)
  s[i] = (s[i].ord.next % 256).chr
end

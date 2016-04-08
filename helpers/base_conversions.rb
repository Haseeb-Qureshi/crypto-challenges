HEX_CHARS = Set.new(('a'..'f').to_a + (0..9).to_a)

def hex_to_b64(hex)
  [hex_to_ascii(hex)].pack("m0")
end

def hex_to_ascii(hex)
  hex.scan(/../).map { |slice| slice.hex.chr }.join
end

def b64_to_hex(b64)
  b64_to_ascii(b64).unpack("H*").first
end

def b64_to_ascii(b64)
  b64.unpack("m0").first
end

def is_hex?(input)
  input.chars.all? { |char| HEX_CHARS.include?(char) }
end

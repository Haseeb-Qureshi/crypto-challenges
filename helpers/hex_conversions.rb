def hex_to_b64(hex)
  [hex_to_ascii(hex)].pack("m0")
end

def hex_to_ascii(hex)
  hex.scan(/../).map { |slice| slice.hex.chr }.join
end

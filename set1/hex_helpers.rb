def hex_to_b64(hex)
  [hex_to_plaintext(hex)].pack("m0")
end

def hex_to_plaintext(hex)
  hex.scan(/../).map { |slice| slice.hex.chr }.join
end

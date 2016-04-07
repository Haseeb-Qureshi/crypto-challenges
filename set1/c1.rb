def challenge_1
  Hex.new('49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d')
     .to_b64 == "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
end

def challenge_1_binary
  hex_to_b64(
    '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
  ) == "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
end

def hex_to_b64(hex)
  [hex_to_plaintext(hex)].pack("m0")
end

def hex_to_plaintext(hex)
  hex.scan(/../).map { |slice| slice.hex.chr }.join
end

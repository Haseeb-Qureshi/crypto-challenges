require_relative '../helpers/padding'

def challenge_9
  pkcs7_padding("YELLOW SUBMARINE", 10) == "YELLOW SUBMARINE\x04\x04\x04\x04"
end

# Write a function that takes a plaintext, determines if it has valid PKCS#7 padding, and strips the padding off.
#
# The string:
#
# "ICE ICE BABY\x04\x04\x04\x04"
# ... has valid padding, and produces the result "ICE ICE BABY".
#
# The string:
#
# "ICE ICE BABY\x05\x05\x05\x05"
# ... does not have valid padding, nor does:
#
# "ICE ICE BABY\x01\x02\x03\x04"

require_relative '../helpers/padding'

def has_valid_padding?(str)
  begin
    PCKS7.unpad(str)
    true
  rescue PCKS7::InvalidPaddingError => e
    false
  end
end

def test
  has_valid_padding?("ICE ICE BABY\x04\x04\x04\x04") &&
    PCKS7.unpad("ICE ICE BABY\x04\x04\x04\x04") == "ICE ICE BABY" &&
    !has_valid_padding?("ICE ICE BABY\x05\x05\x05\x05") &&
    !has_valid_padding?("ICE ICE BABY\x01\x02\x03\x04")
end

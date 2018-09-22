# Suppose you are told that the one time pad encryption of the message 'attack at dawn' is 6c73d5240a948c86981bc294814d
#
# What would be the one time pad encryption of the message 'attack at dusk' under the same OTP key?

require_relative '../base/hex'
INPUT = '6c73d5240a948c86981bc294814d'

def get_changed_otp
  bytes = Hex.to_bytes(INPUT)
  bytes[-3] ^= 'u'.ord ^ 'a'.ord
  bytes[-2] ^= 's'.ord ^ 'w'.ord
  bytes[-1] ^= 'k'.ord ^ 'n'.ord
  bytes.pack('c*').unpack('H*').first
end

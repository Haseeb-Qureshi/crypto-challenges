# Generate a random AES key.
#
# Combine your padding code and CBC code to write two functions.
#
# The first function should take an arbitrary input string, prepend the string:
#
# "comment1=cooking%20MCs;userdata="
# .. and append the string:
#
# ";comment2=%20like%20a%20pound%20of%20bacon"
# The function should quote out the ";" and "=" characters.
#
# The function should then pad out the input to the 16-byte AES block length and encrypt it under the random AES key.
#
# The second function should decrypt the string and look for the characters ";admin=true;" (or, equivalently, decrypt, split the string on ";", convert each resulting string into 2-tuples, and look for the "admin" tuple).
#
# Return true or false based on whether the string exists.

require_relative '../helpers/padding'
require_relative '../helpers/aes'
require_relative '../helpers/binary'

def test
  false
end

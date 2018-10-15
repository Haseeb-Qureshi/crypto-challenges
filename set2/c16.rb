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
require 'securerandom'

@super_secret_key ||= SecureRandom.random_bytes(16)

def construct_query(input)
  "comment=1&cooking%MCs;userdata=" +
    input.gsub(';', "';'").gsub('=', "'='") +
    ";comment2=%20like%20a%20pound%20of%20bacon"
end

def oracle(input)
  AES.cbc_encrypt(@super_secret_key, construct_query(input))
end

def is_admin?(ciphertext)
  plaintext = AES.cbc_decrypt(@super_secret_key, ciphertext)
  plaintext.include?(';admin=true;')
end

# If you've written the first function properly, it should not be possible to provide user input to it that will generate the string the second function is looking for. We'll have to break the crypto to do that.
#
# Instead, modify the ciphertext (without knowledge of the AES key) to accomplish this.
#
# You're relying on the fact that in CBC mode, a 1-bit error in a ciphertext block:
#
# Completely scrambles the block the error occurs in
# Produces the identical 1-bit error(/edit) in the next ciphertext block.

def encrypted_admin_payload
  raise 'Bad block size' unless AES.detect_block_size { |x| oracle(x) } == 16
  raise 'Is ECB??' if AES.is_ecb? { |x| oracle(x) }

  query = construct_query("")
  length = query.length
  dangling = length % 16
  final_plaintext_block = PCKS7.pad(query[-dangling..-1]).flatten.pack('c*')
  desired_final_block = PCKS7.pad(';admin=true;h=i').flatten.pack('c*')

  # inject the difference (xored) into the second to last block of ciphertext

  difference = pairwise_xor(final_plaintext_block, desired_final_block).pack('c*')

  ciphertext = oracle("")

  second_to_last_block = ciphertext[-32...-16]
  jiggered_second_to_last = pairwise_xor(second_to_last_block, difference).pack('c*')
  ciphertext[0...-32] + jiggered_second_to_last + ciphertext[-16..-1]
end

def test
  is_admin?(encrypted_admin_payload)
end

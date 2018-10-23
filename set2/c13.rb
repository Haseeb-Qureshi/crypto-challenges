# Write a k=v parsing routine, as if for a structured cookie. The routine should take:
#
# foo=bar&baz=qux&zap=zazzle
# ... and produce:
#
# {
#   foo: 'bar',
#   baz: 'qux',
#   zap: 'zazzle'
# }
# (you know, the object; I don't care if you convert it to JSON).
#
# Now write a function that encodes a user profile in that format, given an email address. You should have something like:
#
# profile_for("foo@bar.com")
# ... and it should produce:
#
# {
#   email: 'foo@bar.com',
#   uid: 10,
#   role: 'user'
# }
# ... encoded as:
#
# email=foo@bar.com&uid=10&role=user
# Your "profile_for" function should not allow encoding metacharacters (& and =). Eat them, quote them, whatever you want to do, but don't let people set their email address to "foo@bar.com&role=admin".
# Now, two more easy functions. Generate a random AES key, then:
#
# Encrypt the encoded user profile under the key; "provide" that to the "attacker".
# Decrypt the encoded user profile and parse it.
# Using only the user input to profile_for() (as an oracle to generate "valid" ciphertexts) and the ciphertexts themselves, make a role=admin profile.

require_relative '../helpers/aes'
require_relative '../helpers/padding'

@id = 0

def parse(query)
  query.split('&').
        map { |field| field.split('=') }.
        to_h
end

def profile_for(email)
  @id += 1
  "email=#{email.delete('=').delete('&')}&uid=#{@id}&role=user"
end

KEY_C13 = AES.random_key

def oracle(email)
  AES.ecb_encrypt(KEY_C13, profile_for(email), PCKS7)
end

def decrypt_profile(ciphertext)
  parse(AES.ecb_decrypt(KEY_C13, ciphertext, PCKS7))
end

def create_admin_profile
  10.times { oracle("") }
  block_size = AES.detect_block_size { |x| oracle(x) }
  raise 'damn' unless AES.is_ecb?(block_size) { |x| oracle(x) }
  raise 'wrong block block size' unless block_size == 16

  # assuming 16 byte blocks...
  # <-6-->  x   <-----13----> total bytes
  # email=hello&uid=12&role=user

  # need to encrypt a block of just "admin" plus padding as the second block
  # so should be aligned as:
  # 6 + p + 16 = 32
  # 22 + p = 32
  # p = 10 bytes
  admin_block = oracle(' ' * 10 + PCKS7.pad('admin').flatten.pack('c*'))[16..31]

  # now I need to create a query with role= as the end of a block
  # <-6-->  x   <-----13----> total bytes
  # email=hello&uid=12&role=user
  # 6 + x + 13 = 32
  # 19 + x = 32
  # x = 13

  raise unless 'hax@gmail.com'.length == 13

  clipped_ciphertext = oracle('hax@gmail.com')[0...-16]

  # by combining the two, I should now have a profile with role=admin
  clipped_ciphertext + admin_block
end

def test
  decrypt_profile(create_admin_profile)['role'] == 'admin'
end

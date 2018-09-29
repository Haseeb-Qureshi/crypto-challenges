# Now that you have ECB and CBC working:

# Write a function to generate a random AES key; that's just 16 random bytes.

# Write a function that encrypts data under an unknown key --- that is, a function that generates a random key and encrypts under it.

# The function should look like:

# encryption_oracle(your-input)
# => [MEANINGLESS JIBBER JABBER]
# Under the hood, have the function append 5-10 bytes (count chosen randomly) before the plaintext and 5-10 bytes after the plaintext.

# Now, have the function choose to encrypt under ECB 1/2 the time, and under CBC the other half (just use random IVs each time for CBC). Use rand(2) to decide which to use.

# Detect the block cipher mode the function is using each time. You should end up with a piece of code that, pointed at a block box that might be encrypting ECB or CBC, tells you which one is happening.
require 'set'
require_relative '../helpers/aes'
require_relative '../helpers/padding'

def encryption_oracle(plaintext)
  key = AES.random_key
  bytes_to_prepend = SecureRandom.random_bytes(rand(5..10))
  bytes_to_append = SecureRandom.random_bytes(rand(5..10))
  input = bytes_to_prepend + plaintext + bytes_to_append

  if rand(2) == 1
    [AES.cbc_encrypt(key, input), :CBC]
  else
    [AES.ecb_encrypt(key, input, PCKS7), :ECB]
  end
end

def test
  plaintext = "0123456789"

  10.times.all? do
    ciphertext, truth = encryption_oracle(plaintext)
    if ciphertext.length == 32
      truth == :ECB
    elsif ciphertext.length == 48
      truth == :CBC
    else
      raise "wtf?"
    end
  end
end

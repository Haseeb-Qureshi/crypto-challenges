require_relative '../ciphers/simple_xor/cipher'

def challenge_5
  key = "ICE"
  message = "Burning 'em, if you ain't quick and nimble\n"\
            "I go crazy when I hear a cymbal"

  cipher = XORCipher.new(message, key)

  cipher.encrypt!

  should_be_ciphertext = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623"\
                         "d63343c2a26226324272765272a282b2f20430a652e2c652a"\
                         "3124333a653e2b2027630c692b20283165286326302e27282f"

  cipher.to_hex == should_be_ciphertext
end

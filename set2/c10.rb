# Implement CBC mode by hand by taking the ECB function you wrote earlier, making it encrypt instead of decrypt (verify this by decrypting whatever you encrypt to test), and using your XOR function from the previous exercise to combine them.

# The file here is intelligible (somewhat) when CBC decrypted against "YELLOW SUBMARINE" with an IV of all ASCII 0 (\x00\x00\x00 &c)

require_relative '../helpers/aes'

def test
  ciphertext = File.readlines(__dir__ + '/c10_testfile.txt').map(&:chomp).join
  p AES.cbc_decrypt('YELLOW SUBMARINE', ciphertext.prepend("\x00" * 16))
end

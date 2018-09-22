# In this file are a bunch of hex-encoded ciphertexts.
#
# One of them has been encrypted with ECB.
#
# Detect it.
#
# Remember that the problem with ECB is that it is stateless and deterministic; the same 16 byte plaintext block will always produce the same 16 byte ciphertext.

require_relative '../base/hex'

def find_encrypted_ciphertext
  inputs = File.readlines(__dir__ + '/c8_testfile.txt').map(&:chomp)
  inputs.max_by { |text| repeated_block_count(text) }
end

def repeated_block_count(text)
  bytes = Hex.to_bytes(text)
  bytes.each_slice(16)
       .group_by { |block| block }
       .map { |k, blocks| blocks.length }
       .max
end

def test
  find_encrypted_ciphertext == "d880619740a8a19b7840a8a31c810a3d08649af70dc06f4fd5d2d69c744cd283e2dd052f6b641dbf9d11b0348542bb5708649af70dc06f4fd5d2d69c744cd2839475c9dfdbc1d46597949d9c7e82bf5a08649af70dc06f4fd5d2d69c744cd28397a93eab8d6aecd566489154789a6b0308649af70dc06f4fd5d2d69c744cd283d403180c98c8f6db1f2a3f9c4040deb0ab51b29933f2c123c58386b06fba186a"
end

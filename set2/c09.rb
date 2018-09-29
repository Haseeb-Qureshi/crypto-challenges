# One way we account for irregularly-sized messages is by padding, creating a plaintext that is an even multiple of the blocksize. The most popular padding scheme is called PKCS#7.

# So: pad any block to a specific block length, by appending the number of bytes of padding to the end of the block.
require_relative '../helpers/padding'

def pcks7(block, length)
  PCKS7.pad(block, length).flatten.pack('c*')
end

def test
  pcks7("YELLOW SUBMARINE", 20) == "YELLOW SUBMARINE\x04\x04\x04\x04"
end

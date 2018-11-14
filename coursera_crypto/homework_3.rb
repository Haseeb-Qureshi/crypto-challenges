# Write a program that will, given a file as input, compute the h_0 hash according to the rules set out in problem set 3.
require 'digest'

def compute_hash(filename)
  bytes = File.read("#{__dir__}/#{filename}", encoding: "ASCII-8BIT").chars
  blocks = bytes.each_slice(1024).map(&:join).to_a.reverse

  blocks.each_index do |i|
    next if i == 0 # first block is bare
    blocks[i] += Digest::SHA2.digest(blocks[i - 1])
  end

  Digest::SHA2.hexdigest(blocks.last)
end

p compute_hash("test.mp4")

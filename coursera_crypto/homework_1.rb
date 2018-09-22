require_relative '../base/hex'
require 'set'
require 'pry'

TARGET = '32510ba9babebbbefd001547a810e67149caee11d945cd7fc81a05e9f85aac650e9052ba6a8cd8257bf14d13e6f0a803b54fde9e77472dbff89d71b57bddef121336cb85ccb8f3315f4b52e301d16e9f52f904
'

COMMON_PHRASES =  ['e that all', ' unhappy ', " commenting on ", 'ys from a guy who ', ' safe from your little sister, and that which will k', 'to use brute force to break the code ', 'to use brute force to break you', ' government ', 'in stealing cars - Marc Rotenburg commenting on Cli', 'nt and consumes more power for', 'ur government - Bruce Schneid', 'There are two types of cryptography - that which will keep secrets safe from your little sister, and that which will keep secrets safe from from your government - Bruce Schneier', "You don't want to buy a set of car keys from a guy who specializes in stealing cars - Marc Rotenberg commenting on Clipper", "There are two types of cyptography: one that allows the Government to use brute force to break the code, and one that requires the Government to use brute force to break you"]

' that will keep secrets safe from your little sister, and that which will keep secrets safe from your government'
GOOD_LETTERS = Set.new([*'A'..'Z', *'a'..'z', ' ', '.', ',', '-', "'"].map(&:ord))


KEY = '66396e89c9dbd8cc9874352acd6395102eafce78aa7fed28a07f6bc98d29c50b69b0339a19f8aa401a9c6d708f80c066c763fef0123148cdd8e802d05ba98777335daefcecd59c433a6b268b60bf4ef03c9a611098bb3e9a3161edc7b804a33522cfd202d2c68c57376edba8c2ca50027c61246ce2a12b0c4502175010c0a1ba4625786d911100797d8a47e98b0204c4ef06c867a950f11ac989dea88fd1dbf16748749ed4c6f45b384c9d96c4'

def break_many_time_pad
  inputs = File.readlines(__dir__ + '/homework_1_data.txt').map(&:chomp)
  inputs.map!(&Hex.method(:to_bytes))

  inputs.each_cons(2).to_a[4..6].map.with_index do |(i1, i2), idx|
    puts
    puts "-" * 12
    puts
    xor = pairwise_xor(i1, i2)

    COMMON_PHRASES.each do |common_phrase|
      new_xor = xor.dup
      phrase = common_phrase.bytes
      i = 0
      while i < new_xor.length - phrase.length
        slice = new_xor[i..(i + phrase.length)]
        if all_ascii?(pairwise_xor(slice, phrase))
          0.upto(phrase.length - 1) { |idx| new_xor[i + idx] ^= phrase[idx] }
          i += phrase.length
        else
          new_xor[i] = '_'.ord
          i += 1
        end
      end
      i.upto(new_xor.length - 1) { |i| new_xor[i] = '_'.ord }
      p common_phrase.ljust(15) + ':  ' + new_xor.pack('c*')
    end
  end
end

def reveal_plaintexts
  inputs = File.readlines(__dir__ + '/homework_1_data.txt')
               .map(&:chomp)
               .map(&Hex.method(:to_bytes))
  inputs.each do |input|
    puts pairwise_xor(input, Hex.to_bytes(KEY)).pack('c*')
  end

  puts "Decrypted target: "
  p pairwise_xor(Hex.to_bytes(TARGET), Hex.to_bytes(KEY)).pack('c*')
end

def all_ascii?(bytes)
  bytes.all? { |byte| GOOD_LETTERS.include?(byte) }
end

def pairwise_xor(i1, i2)
  i1.zip(i2).select(&:all?).map { |a, b| a ^ b }
end

def test
  reveal_plaintexts
end

test

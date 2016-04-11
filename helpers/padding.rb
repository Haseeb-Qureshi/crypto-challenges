def pkcs7_padding(message, block_length, padding_byte = "\x04")
  length = message.bytesize
  final_length = length.fdiv(block_length).ceil * block_length
  padding_bytes = final_length - length
  ([message] + [padding_byte] * padding_bytes).join
end

# encrypt
iverilog -g2012 -o build/tb_encrypt.vvp src/*.sv tb/tb_encrypt.sv && vvp build/tb_encrypt.vvp

# decrypt
iverilog -g2012 -o build/tb_decrypt.vvp src/*.sv tb/tb_decrypt.sv && vvp build/tb_decrypt.vvp

# decrypt_hash
iverilog -g2012 -o build/tb_decrypt_hash.vvp src/*.sv tb/tb_decrypt_hash.sv && vvp build/tb_decrypt_hash.vvp

# roundtrip
iverilog -g2012 -o build/tb_roundtrip.vvp src/*.sv tb/tb_roundtrip.sv && vvp build/tb_roundtrip.vvp 

# flags
iverilog -g2012 -o build/tb_flags.vvp src/*.sv tb/tb_flags.sv && vvp build/tb_flags.vvp
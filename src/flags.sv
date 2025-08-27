module flags(
input logic [7:0] plain,
input logic [7:0] enc_in,
input logic [7:0] ref_hash,
output logic valid_flag,
output logic hash_match
);
logic [7:0] dec;
decrypt D(.din(enc_in), .dout(dec));


logic [7:0] h;
hash H(.enc(enc_in), .h(h));


assign valid_flag = (dec == plain);
assign hash_match = (h == ref_hash);
endmodule
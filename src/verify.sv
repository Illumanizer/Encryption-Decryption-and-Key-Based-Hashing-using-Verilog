module verify (
input logic [7:0] plain,
input logic [7:0] enc_in,
input logic [7:0] ref_hash,
output logic valid_flag,
output logic hash_match,
output logic enc_match
);
logic [7:0] dec;
decrypt D(.din(enc_in), .dout(dec));

logic [7:0] reenc;
encrypt E(.din(dec), .dout(reenc));

logic [7:0] h;
hash H(.enc(enc_in), .h(h));


assign valid_flag = (dec == plain);
assign hash_match = (h == ref_hash);
assign enc_match  = (reenc == enc_in);
endmodule
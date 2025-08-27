module encrypt(
input logic [7:0] din,
output logic [7:0] dout
);

wire[7:0] s, p, h;


compute_sbox enc_sbox(.x(din), .y(s));

permute_bits enc_permute(.data_in(s), .data_out(p));

round_key enc_RoundKey(.data_in(p), .data_out(h));

assign dout = h;

endmodule
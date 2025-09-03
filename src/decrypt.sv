module decrypt(
  input  logic [7:0] din,
  output logic [7:0] dout
);

  logic [7:0] a,b,y_inv;

  round_key dec_RoundKey(.data_in(din), .data_out(a));

  permute_bits dec_permute(.data_in(a), .data_out(b));

  compute_inverse_sbox u1(.x(b), .y(y_inv));

  assign dout = y_inv;
endmodule
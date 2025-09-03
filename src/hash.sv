module hash(
  input  logic [7:0] enc,
  output logic [7:0] h
);
  localparam logic [7:0] K = 8'h5A;

  logic [7:0] mix;

  round_key hash_round_key(.data_in(enc), .data_out(mix));

  assign h   = mix << 2;    
     
endmodule

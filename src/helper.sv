module permute_bits(input  logic [7:0] data_in,
                    output logic [7:0] data_out);

  assign data_out = {data_in[3:0], data_in[7:4]};

endmodule

module round_key(input  logic [7:0] data_in,
                 output logic [7:0] data_out);

  localparam logic [7:0] k = 8'h5A;
  assign data_out = data_in ^ k;
endmodule
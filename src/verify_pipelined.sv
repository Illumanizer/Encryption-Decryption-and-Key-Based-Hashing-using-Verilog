module verify_pipelined(
  input  logic clk,
  input  logic rst_n,
  input  logic [7:0]  plain,
  input  logic [7:0]  enc_in,
  input  logic [7:0]  ref_hash,
  output logic enc_match,
  output logic hash_match,
  output logic valid_flag
);

  logic [7:0] dec;        
  logic [7:0] reenc;      
  logic [7:0] h;          

  // pipeline registers (1 cycle)
  logic [7:0] dec_reg;
  logic [7:0] plain_d, ref_hash_d;

  decrypt u_dec (
    .din(enc_in),
    .dout(dec)
  );

  // stage boundary: register decrypted plaintext
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dec_reg <= 8'h00;
      plain_d <= 8'h00;
      ref_hash_d <= 8'h00;
    end else begin
      dec_reg <= dec;         // pipeline: dec -> dec_reg
      plain_d <= plain;       // align plain to pipeline
      ref_hash_d <= ref_hash; // align ref_hash to pipeline
    end
  end

  encrypt u_enc (
    .din(dec_reg),   
    .dout(reenc)
  );

  hash u_hash (
    .enc(enc_in),    
    .h(h)
  );

  logic enc_match_c, hash_match_c, valid_c;

  assign enc_match_c  = (reenc == enc_in);     
  assign hash_match_c = (h == ref_hash_d);     
  assign valid_c      = enc_match_c & hash_match_c;


  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      enc_match  <= 1'b0;
      hash_match <= 1'b0;
      valid_flag <= 1'b0;
    end else begin
      enc_match  <= enc_match_c;
      hash_match <= hash_match_c;
      valid_flag <= valid_c;
    end
  end

endmodule

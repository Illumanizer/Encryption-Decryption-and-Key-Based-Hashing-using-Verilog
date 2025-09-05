`timescale 1ns/1ps
module tb_verify_pipelined;

  reg clk = 0;
  reg rst_n = 0;
  always #5 clk = ~clk;

  reg  [7:0] plain;
  reg  [7:0] enc_in;
  reg  [7:0] ref_hash;

  wire valid_flag;
  wire hash_match;
  wire enc_match;

  verify_pipelined DUT (
    .clk        (clk),
    .rst_n      (rst_n),
    .plain      (plain),
    .enc_in     (enc_in),
    .ref_hash   (ref_hash),
    .valid_flag (valid_flag),
    .hash_match (hash_match),
    .enc_match  (enc_match)
  );

  integer fail_count = 0;

  task check(input [7:0] enc_given,input [7:0] expected_plain,input [7:0] expected_hash);
    begin
      enc_in   = enc_given;
      plain    = expected_plain;
      ref_hash = expected_hash;

      @(posedge clk); // allow comb to settle before pipeline registers capture
      @(posedge clk); // dec -> dec_reg
      @(posedge clk); // reenc computed and flags registered


      if (!valid_flag) begin
         $display("[ERROR] Decryption check FAILED: enc=%02h plain=%02h got_plain=%02h", enc_given, expected_plain,DUT.dec_reg);
         fail_count = fail_count + 1;
      end

      if (!enc_match) begin
        $display("[ERROR] Re-encryption check FAILED: expected_enc=%02h got_enc=%02h", enc_given,DUT.reenc);
        fail_count = fail_count + 1;
      end

      if (!hash_match) begin
         $display("[ERROR] Hash check FAILED: enc=%02h expected_hash=%02h got_hash=%02h", enc_given, expected_hash, DUT.h);
         fail_count = fail_count + 1;
      end

      if (valid_flag && enc_match && hash_match)
      $display("PASS: enc=%02h plain=%02h hash=%02h  (flags: valid=%0b enc_match=%0b hash_match=%0b)",
               enc_given, expected_plain, expected_hash, valid_flag, enc_match, hash_match);

     @(posedge clk);
    end
  endtask

  initial begin
    // assert reset for a few clock cycles
    rst_n = 0;
    repeat (4) @(posedge clk);
    rst_n = 1;
    @(posedge clk);

    check(8'h6C, 8'h00, 8'hD8);
    check(8'h9D, 8'h01, 8'h1C);
    check(8'h62, 8'h41, 8'hE0);
    check(8'h65, 8'h7E, 8'hFC);
    check(8'h3A, 8'hA5, 8'h80);
    check(8'h3B, 8'hFF, 8'h84);

    if(fail_count==0)
      $display("\ntb_verify_pipelined OK\n");
    else
      $display("\n tb_verify_pipelined FAILED count=%0d \n", fail_count);
    $finish;
  end
endmodule

`timescale 1ns/1ps
module tb_flags;

  reg  [7:0] plain;
  reg  [7:0] enc_in;
  reg  [7:0] ref_hash;

  wire valid_flag;
  wire hash_match;

  flags DUT (
    .plain(plain),
    .enc_in(enc_in),
    .ref_hash(ref_hash),
    .valid_flag(valid_flag),
    .hash_match(hash_match)
  );

  task check(input [7:0] e_in, input [7:0] exp_p, input [7:0] exp_h);
    begin
      enc_in   = e_in;
      plain    = exp_p;
      ref_hash = exp_h;
      #1;

      assert (valid_flag)
        else $fatal(1, "valid_flag FAIL: e=%02h plain=%02h dec!=plain", e_in, exp_p);

      assert (hash_match)
        else $fatal(1, "hash_match FAIL: e=%02h ref_h=%02h got=%02h", e_in, exp_h, DUT.h);

      $display("PASS flags: e=%02h -> plain=%02h ref_h=%02h", e_in, exp_p, exp_h);

      #5;
    end
  endtask

  initial begin
    // enc_in, expected_plain, expected_hash
    check(8'h6C, 8'h00, 8'hD8);
    check(8'h9D, 8'h01, 8'h1C);
    check(8'h62, 8'h41, 8'hE0);
    check(8'h65, 8'h7E, 8'hFC);
    check(8'h3A, 8'hA5, 8'h80);
    check(8'h3B, 8'hFF, 8'h84);

    $display("tb_flags OK");
    $finish;
  end
endmodule

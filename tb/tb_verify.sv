`timescale 1ns/1ps
module tb_verify;

  reg  [7:0] plain;
  reg  [7:0] enc_in;
  reg  [7:0] ref_hash;

  wire valid_flag;
  wire hash_match;
  wire enc_match;

  verify DUT (
    .plain     (plain),
    .enc_in    (enc_in),
    .ref_hash  (ref_hash),
    .valid_flag(valid_flag),
    .hash_match(hash_match),
    .enc_match (enc_match)
  );

  integer fail_count = 0;

  task check(input [7:0] enc_given,input [7:0] expected_plain,input [7:0] expected_hash);
    begin
      enc_in   = enc_given;
      plain    = expected_plain;
      ref_hash = expected_hash;
      #1;

      assert (valid_flag)
        else begin
           $error( "Decryption check FAILED: enc=%02h plain=%02h got=%02h",enc_given, expected_plain,enc_in);
            fail_count = fail_count + 1;
        end      

      assert (enc_match)
        else begin
          $error( "Re-encryption check FAILED: dec->enc != %02h", enc_given);
          fail_count = fail_count + 1;
        end

      assert (hash_match)
        else begin
           $error( "Hash check FAILED: enc=%02h got=%02h",enc_given, expected_hash);
           fail_count = fail_count + 1;
        end

       $display("PASS case: enc=%02h plain=%02h hash=%02h got=%02h",
                enc_given, expected_plain, expected_hash,DUT.h);

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

    if(fail_count==0)
      $display("tb_verify OK");
    else
      $display("tb_verify FAILED count=%0d", fail_count);
    $finish;
  end
endmodule

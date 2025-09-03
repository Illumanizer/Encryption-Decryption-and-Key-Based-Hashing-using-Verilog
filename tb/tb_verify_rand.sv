`timescale 1ns/1ps
module tb_verify_rand;


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

  wire [7:0] dec_gold;
  wire [7:0] reenc_gold;
  wire [7:0] hash_gold;

  decrypt GDEC (.din(enc_in), .dout(dec_gold));
  encrypt GENC (.din(dec_gold), .dout(reenc_gold));
  hash    GHASH(.enc(enc_in),  .h(hash_gold));

  integer fail_count = 0;

  task automatic run_random_case;
    begin
      enc_in = $urandom_range(0, 255); // random ciphertext
      #2;

      plain    = dec_gold;
      ref_hash = hash_gold;
      #1; 

      assert(valid_flag)
        else begin 
          $error("Decryption FAIL: cipher=%02h exp=%02h", enc_in, dec_gold);
          fail_count = fail_count + 1;
        end

      assert(enc_match)
        else begin 
          $error( "Re-encryption FAIL: cipher=%02h reenc=%02h", enc_in, reenc_gold);
          fail_count = fail_count + 1;
        end

      assert(hash_match)
        else begin 
          $error( "Hash FAIL: cipher=%02h exp=%02h got=%02h", enc_in, hash_gold, DUT.h);
          fail_count = fail_count + 1;
        end

      $display("PASS rand: cipher=%02h plain=%02h hash=%02h",
                enc_in, dec_gold, hash_gold);
    end
  endtask

  initial 
  begin
    repeat (10) 
    begin
      run_random_case();
      #5;
    end

    if(fail_count==0)
      $display("tb_verify_rand OK");
    else
      $display("tb_verify_rand FAILED count=%0d", fail_count);

    $finish;
  end

endmodule

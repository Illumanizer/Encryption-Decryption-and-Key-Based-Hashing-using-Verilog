`timescale 1ns/1ps
module tb_decrypt_hash;

  reg  [7:0] e;      // ciphertext to feed both blocks
  wire [7:0] d, h;

  decrypt UDEC (.din(e), .dout(d));
  hash    UH   (.enc(e), .h(h));

  integer fail_count = 0;

  task check; input [7:0] e_in, exp_p, exp_h;
    begin
      e = e_in; #1;

      assert (d === exp_p)
        else begin 
          $error("decrypt mismatch: input=%02h output=%02h expected=%02h @time=%0t",e_in, d, exp_p, $time);
          fail_count = fail_count + 1;
        end

      assert (h === exp_h)
        else begin
           $error( "hash mismatch: input=%02h hash=%02h expected=%02h @time=%0t",e_in, h, exp_h, $time);
           fail_count = fail_count + 1;
        end

      $display("PASS dec+hash: input=%02h decrypted=%02h hash=%02h", e, d, h);
      #5;
    end
  endtask

  initial begin
    //input |  expected plain | expected hash
    check(8'h6C, 8'h00, 8'hD8);
    check(8'h9D, 8'h01, 8'h1C);
    check(8'h62, 8'h41, 8'hE0);
    check(8'h65, 8'h7E, 8'hFC);
    check(8'h3A, 8'hA5, 8'h80);
    check(8'h3B, 8'hFF, 8'h84);

    if(fail_count == 0)
      $display("tb_decrypt_hash OK");
    else
      $display("tb_decrypt_hash FAILED count=%0d", fail_count);
    $finish;
  end
endmodule

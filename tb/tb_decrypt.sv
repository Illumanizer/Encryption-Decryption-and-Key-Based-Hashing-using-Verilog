`timescale 1ns/1ps
module tb_decrypt;

  reg  [7:0] cin;     // ciphertext in
  wire [7:0] pout;    // plaintext out

  decrypt DUT(.din(cin), .dout(pout));

  task check(input [7:0] e_in, input [7:0] exp_p);
    begin
      cin = e_in; #1;
      assert (pout === exp_p)
        else $fatal(1, "decrypt mismatch: input=%02h output=%02h expexted=%02h @time=%0t",e_in, pout, exp_p, $time);
      $display("  %02h  ->  %02h :  PASSED", e_in, pout);
      #5;
    end
  endtask

  initial begin
    $display("input -> decrypted");
    check(8'h6C, 8'h00);
    check(8'h9D, 8'h01);
    check(8'h62, 8'h41);
    check(8'h65, 8'h7E);
    check(8'h3A, 8'hA5);
    check(8'h3B, 8'hFF);

    $display("tb_decrypt OK");
    $finish;
  end
endmodule

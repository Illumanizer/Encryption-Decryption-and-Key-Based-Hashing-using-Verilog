`timescale 1ns/1ps
module tb_encrypt;

  reg  [7:0] in;
  wire [7:0] out;

  encrypt DUT(.din(in), .dout(out));
  integer fail_count = 0;

  task check(input [7:0] x, input [7:0] exp_e);
    begin
      in = x; #1;
      assert (out === exp_e)
        else begin
          $error( "encrypt mismatch: input=%02h output=%02h expected=%02h @time=%0t", x, out, exp_e, $time);
          fail_count = fail_count + 1;
        end
      $display("  %02h  ->  %02h :  PASSED", x, out);
      #5;
    end
  endtask

  initial begin
    $display("input -> encrypted");
    check(8'h00, 8'h6C);//input expected encrypted
    check(8'h01, 8'h9D);
    check(8'h41, 8'h62);
    check(8'h7E, 8'h65);
    check(8'hA5, 8'h3A);
    check(8'hFF, 8'h3B);


    if(fail_count==0)
      $display("tb_encrypt OK");
    else
      $display("tb_encrypt FAILED count=%0d", fail_count);
    $finish;
  end
endmodule

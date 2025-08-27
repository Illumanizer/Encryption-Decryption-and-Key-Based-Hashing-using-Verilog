`timescale 1ns/1ps
module tb_roundtrip_rand;

  reg  [7:0] e, p0;
  wire [7:0] p_from_e, e2, h;
  wire [7:0] e0, p1;

  // DUTs
  decrypt UDEC  (.din(e),        .dout(p_from_e));
  encrypt UENC  (.din(p_from_e), .dout(e2));
  hash    UHASH (.enc(e),        .h(h));

  encrypt UENC2 (.din(p0), .dout(e0));
  decrypt UDEC2 (.din(e0), .dout(p1));

  integer i=6;
  integer seed;  // variable seed for $urandom

  initial begin
    seed = 32'h00C0FFEE;
    $urandom(seed);  // initialize RNG with variable seed

    repeat (i) begin
      e  = $urandom; e  = e[7:0];
      p0 = $urandom; p0 = p0[7:0];
      #1;

      assert (e2 == e)
        else $fatal(1, "FAIL re-enc: e=%02h re=%02h", e, e2);

      assert (p1 == p0)
        else $fatal(1, "FAIL re-dec: p=%02h got=%02h", p0, p1);

      $display("OK: encrypted=%02h -> plain_test=%02h -> re-encrypted=%02h|",e, p_from_e, e2);
      $display("    hash=%02h | plain_text=%02h -> encrypted=%02h -> decrypted=%02h\n",h, p0, e0, p1);

      #5;
    end

    $display("tb_roundtrip_rand: 6 random trials passed");
    $finish;
  end
endmodule

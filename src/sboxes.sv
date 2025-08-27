module compute_sbox(
input [7:0] x,
output [7:0] y
);
reg [7:0] SBOX [0:255];
initial 
    $readmemh("data/sbox.mem", SBOX);
assign y = SBOX[x];
endmodule


module compute_inverse_sbox(
input [7:0] x,
output [7:0] y
);
reg [7:0] INVSBOX [0:255];
initial 
begin
    $readmemh("data/invsbox.mem", INVSBOX);
end
assign y = INVSBOX[x];
endmodule
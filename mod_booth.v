`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2017 09:11:03 PM
// Design Name: 
// Module Name: mod_booth
// Project Name: 
// Target Devices: Airtex-7(XC7A35T-1CPG236C)
// Tool Versions: 
// Description: radix 4 modified booth multiplication
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module mod_booth(y, m, q);
input[7:0]m;    // First input multiplicand(m)
input[15:8]q;   // second input Multiplier(q)
output [15:0]y;  // final output (m*q)

//Port Data Types
reg [2:0] count[3:0];
reg [8:0] partial[3:0];
reg [15:0] s_partial[3:0];
reg [15:0] gen_result;    // generated result from partial product
wire [8:0] mbar;
integer i,j;  //local variables of integer type
assign mbar = {~m[7],~m}+1; //generate two's complement of mutiplicand m
always@(m,q,mbar)
begin
count[0] = {q[9],q[8],1'b0}; // setting count[0] initially
		for(j=1;j<4;j=j+1)
				count[j] = {q[2*j+9],q[2*j+8],q[2*j+7]};
		for(j=0;j<4;j=j+1)
		begin
		case(count[j])  //recoding cases of radix-4 booth multiplier
3'b001 , 3'b010 : partial[j] = {m[7],m};          // +1*m
3'b011 : 	      partial[j] = {m,1'b0};        // +2*m 
3'b100 : 		  partial[j] = {mbar[7:0],1'b0};// -2*m
3'b101 , 3'b110 : partial[j] = mbar;              // -1*m
default : partial[j] = 0;                         // 0*m for the case 3'b000 and 3'b111
endcase
s_partial[j] = (partial[j]);
			for(i=0;i<j;i=i+1)
				s_partial[j] = {s_partial[j],2'b00}; //shifting operation 2 times left
		end
gen_result=0;   // setting gen_result =0 
			for(j=0;j<4;j=j+1)
				gen_result = gen_result + s_partial[j];
end
assign y= gen_result ;  // final result
endmodule 
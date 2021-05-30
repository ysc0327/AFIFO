module sram_model (
  input RCK_0,
  input WCK_0,
  input [2:0] RA_0,
  input [2:0] WA_0,
  input [31:0] DI,
  input RCS_0,
  input WCS_0,
  output reg [31:0] DO
 );
 
 reg [31:0] memory [0:7];
 
 always @(posedge WCK_0) begin
    if(WCS_0)
	  memory[WA_0] <= DI;
 end
 
 
 always @(posedge RCK_0) begin
    if(RCS_0)
	  DO <= memory[RA_0];
 end
 
endmodule
module synchronizer (
  input clk,
  input rst_n,
  input [3:0] ptr_i;
  output [3:0] prt_o;
  );
  
  reg [3:0] ff_0;
  reg [3:0] ff_1;
  
  always @(posedge clk ,negedge rst_n) begin
    if(!rst_n) begin
	  ff_0 <= 4'd0;
	  ff_1 <= 4'd0;
	end
	else begin
	  ff_0 <= ptr_i;
	  ff_1 <= ff_0;
	end
  end	

  assign ptr_o = ff_1;

endmodule  
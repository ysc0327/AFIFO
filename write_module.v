`timescale 1ns/10ps
module write_module (
  input clk,
  input rst_n,
  input wr,
  input [3:0] rptr_sync,
  
  output full,
  output reg [3:0] wptr,
  output reg [3:0] gray_wptr,
  output wr_mem_rn
  );
  
  wire [3:0] wptr_next;
  assign wptr_next = wptr + {3'b0, (wr& !(full))};
  
  always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
	  wptr <= 4'd0;
	else 
	  wptr <= wptr_next;
  end
  
  always @(posedge clk, negedge rst_n) begin
    if(!rst_n) 
	  gray_ptr <= 4'd0;
	else 
	  gray_ptr <= {1'b0, wptr_next[3:1]} ^ wptr_next;
  end
  
  assign wr_mem_en = wr & (!full);
  
  //need bin vs bin   modify <----
  wire rptr_sync2bin;
  assign rptr_sync2bin[3] = rptr_sync[3];
  assign rptr_sync2bin[2] = rptr_sync2bin[3] ^ rptr_sync[2]; 
  assign rptr_sync2bin[1] = rptr_sync2bin[2] ^ rptr_sync[1]; 
  assign rptr_sync2bin[0] = rptr_sync2bin[1] ^ rptr_sync[0];

  //wptr = binary, rptr_syn2bin = binary
  assign full = (wptr[3] != rptr_sync2bin[3]) & (wptr[2:0] == rptr_sync2bin[2:0]);

endmodule  
  
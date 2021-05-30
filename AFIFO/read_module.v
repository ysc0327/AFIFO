`timescale 1ns/10ps
module read_module (
  input clk,
  input rst_n,
  input rd,
  input [3:0] wptr_sync,
  
  output reg o_valid,
  output reg [3:0] rptr,
  output reg [3:0] gray_rptr,
  output rd_mem_en
  );

  //input port "rd" is connect to slave's port "full_flag"  
  //rd = 1 --> slave can't read, because slave is busy
  //rd = 0 --> slave can   read, because slave is not busy

  wire [3:0] rpt_next;
  wire empty;
  
  assign rptr_next = rptr + (3'b0, (!rd & !empty));  
  
  always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
	  rptr <= 4'd0;
	else 
	  rptr <= rptr_next;
  end
  
  always @(posedge clk, negedge rst_n) begin
    if(!rst_n) 
	  gray_rptr <= 4'd0;
	else 
	  gray_rptr <= {1'b0, rptr_next[3:1]} ^ rptr_next;
  end
  
  assign rd_mem_en = !rd & (!empty);
  
  // need bin vs bin <---modify
  wire [3:0] wptr_sync2bin
  assign wptr_sync2bin[3] = wptr_sync[3];
  assign wptr_sync2bin[2] = wptr_sync2bin[3] ^ wptr_sync[2]; 
  assign wptr_sync2bin[1] = wptr_sync2bin[2] ^ wptr_sync[1]; 
  assign wptr_sync2bin[0] = wptr_sync2bin[1] ^ wptr_sync[0];
  
  //rptr = binary, wptr_syn2bin = binary
  assign empty = (rptr == wptr_sync2bin) ? 1'b1 : 1'b0;
  
  //o_valid   need FF because real sram output have one delay cycle
//  always @(posedge clk, negedge rst_n) begin
//    if(!rst_n)
//	  o_valid <= 0;
//	else if(!rd & (!empty))
//	  o_valid <= 1;
//	// important signal for correct fifo behavior
//	else if(rd & o_valid) //slave full --> rd = 1, so if slave busy we need remain out_valid = 1 and reamin data until slave can receive fifo output data
//	  o_valid <= 1;
//	else
//	  o_valid <= 0;
//  end


  //o_valid 
  always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
	  o_valid <= 0;
	else if(!empty)
	  o_valid <= 1;
	else
	  o_valid <= 0;
  end 
  //use o_valid signal to be fifo_rdy, because real sram output have one delay cycle

  
endmodule  
	  
	  
  
  
  
  
  
  
  
  
  
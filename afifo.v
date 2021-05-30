module afifo (
  input wclk;
  input rclk;
  input rst_n;
  
  // to pipe stage
  input [31:0] pp_d;
  input        pp_rdy;
  output       fifo_full,
  
  // to SM
  input sm_full,
  output [31:0] fifo_d,
  output fifo_rdy
  );
  
  wire [3:0] write_module_ptr;
  wire [2:0] write_module_ptr2mem;
  assign write_module_ptr2mem = write_module_ptr[2:0];
  
  wire [3:0] read_module_ptr;
  wire [2:0] read_module_ptr2mem;
  assign read_module_ptr2mem = read_module_ptr[2:0];
  
  wire wr_en;
  wire rd_en;
  
  // not yet sync
  wire [3:0] wr_gray_cnt2sync;
  wire [3:0] rd_gray_cnt2sync;
  
  // have been sync
  wire [3:0] w_sync_o;
  wire [3:0] r_sync_o;
  
  write_module u_write_module (
    .clk(wclk),
	.rst_n(rst_n),
	.wr(pp_rdy),
	.rptr_sync(r_sync_o),
	.full(fifo_full),
	.wptr(write_module_ptr),
	.gray_wptr(wr_gray_cnt2sync),
	.wr_mem_en(wr_en)
	);
	
  synchronizer sync_0 (
     .clk(rclk),
     .rst_n(rst_n),
	 .ptr_i(wr_gray_cnt2sync),
	 .ptr_o(w_sync_o)
	 );
	 
  read_module u_read_module (
    .clk(wclk),
	.rst_n(rst_n),
	.rd(sm_full),
	.wptr_sync(w_sync_o),
	.o_valid(fifo_rdy),
	.rptr(read_module_ptr),
	.gray_wptr(rd_gray_cnt2sync),
	.rd_mem_en(rd_en)
	);
	
  synchronizer sync_0 (
     .clk(wclk),
     .rst_n(rst_n),
	 .ptr_i(rd_gray_cnt2sync),
	 .ptr_o(r_sync_o)
	 );	 
	 
  //sram_model  please write by yourself  (you can write register_file to achieve sram's behavior)    *fifo ouput need a flip flop 	 
  sram_model u_sram (
     .RCK_0(rclk),
     .WCK_0(wclk),
     .RA_0(read_module_ptr2mem),
     .WA_0(write_module_ptr2mem),
     .DI(pp_d),
     .RCS_0(rd_en),
     .WCS_0(wr_en),
     .DO_0(fifo_d)
    );	 
	 
endmodule	
  
  
  
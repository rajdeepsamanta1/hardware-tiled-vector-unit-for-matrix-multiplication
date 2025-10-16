`include "config_sys.vh"

module vpu_sim_test;

reg clk;
reg reset;
reg start;
 wire [`ADDR_WIDTH-1:0]addr_a;
 wire [`ADDR_WIDTH-1:0]addr_w;
  wire [`ADDR_WIDTH-1:0]addr_res;
 wire [`BUS_WIDTH-1:0]a;
 wire [`BUS_WIDTH-1:0]w;
 wire [`OUT_WIDTH*`ROW_A-1:0]out;
 wire load_a;
wire load_w;
wire deload_out;
wire compute;
//output wire compute,
//wire [$clog2(`ROW_M)-1:0]index_i;
//wire [$clog2(`ROW_M)-1:0]index_j;
//wire [$clog2(`ROW_M)-1:0]index_k;
//wire [$clog2(`ROW_M)-1:0]index_ii_a;
//wire [$clog2(`ROW_M)-1:0]index_jj_a;
//wire [$clog2(`ROW_M)-1:0]index_ii_w;
//wire [$clog2(`ROW_M)-1:0]index_jj_w;
reg test_en;
wire [`DATA_WIDTH-1:0]test_data;
wire deload;
wire store;
wire [`DATA_WIDTH-1:0]sum;
wire [`WEIGHT_WIDTH*`COL_W-1:0]mult_in;
 wire [$clog2(`ROW_A)-1:0]count_deload_a;
 wire [$clog2(`ROW_A)-1:0]count_deload_w;
 wire [15:0]out1;
 wire [15:0]out2;
 wire [15:0]out3;
 wire [15:0]out4;
 wire [$clog2(`ROW_A*`ROW_A)-1:0]count_store;
 wire reset_sys;

vpu_test_top#(
`include "config_sys.vh"
)uut(
.clk(clk),
.reset(reset),
.start(start),
.addr_a(addr_a),
.addr_w(addr_w),
.addr_res(addr_res),
.a(a),
.w(w),
.out(out),
//.compute(compute),
.load_a(load_a),
.load_w(load_w),
.deload_out(deload_out),
.compute(compute),
//.index_i(index_i),
//.index_j(index_j),
//.index_k(index_k),
//.index_ii_a(index_ii_a),
//.index_jj_a(index_jj_a),
//.index_ii_w(index_ii_w),
//.index_jj_w(index_jj_w),
.test_en(test_en),
.test_data(test_data),
.deload(deload),
.store(store),
.sum(sum),
.mult_in(mult_in),
.count_deload_a(count_deload_a),
.count_deload_w(count_deload_w),
.out1(out1),
.out2(out2),
.out3(out3),
.out4(out4),
.count_store(count_store),
.reset_sys(reset_sys)

);

 
 always
 begin
 
 clk=1; #5;
 clk=0; #5;
 
 end
 
 integer i, j;
 
 initial
 begin
 
 reset=1;
 start=0;
 
 #40;
 
 reset=0;
 start=1;
 
 #42600;
 
 start=0;
 
 test_en=1;
 
 
 end
 




endmodule

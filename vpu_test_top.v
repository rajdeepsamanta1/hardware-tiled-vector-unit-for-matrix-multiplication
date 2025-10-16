`include "config_sys.vh"

module vpu_test_top(
input wire clk,
input wire reset,
input wire start,
output wire [`ADDR_WIDTH-1:0]addr_a,
output wire [`ADDR_WIDTH-1:0]addr_w,
output wire [`ADDR_WIDTH-1:0]addr_res,
output wire [`BUS_WIDTH-1:0]a,
output wire [`BUS_WIDTH-1:0]w,
output wire [`OUT_WIDTH*`ROW_A-1:0]out,
output wire load_a,
output wire load_w,
output wire deload_out,
output wire compute,
//output wire compute,
//output wire [$clog2(`ROW_M)-1:0]index_i,
//output wire [$clog2(`ROW_M)-1:0]index_j,
//output wire [$clog2(`ROW_M)-1:0]index_k,
//output wire [$clog2(`ROW_M)-1:0]index_ii_a,
//output wire [$clog2(`COL_M)-1:0]index_jj_a,
//output wire [$clog2(`ROW_N)-1:0]index_ii_w,
//output wire [$clog2(`COL_N)-1:0]index_jj_w,
input wire test_en,
output wire [`DATA_WIDTH-1:0]test_data,
output wire deload,
output wire store,
output wire [`DATA_WIDTH-1:0]sum,
output wire [`WEIGHT_WIDTH*`COL_W-1:0]mult_in,
output wire [$clog2(`ROW_A)-1:0]count_deload_a,
output wire [$clog2(`ROW_A)-1:0]count_deload_w,
output wire [15:0]out1,
output wire [15:0]out2,
output wire [15:0]out3,
output wire [15:0]out4,
output wire [$clog2(`ROW_A*`ROW_A)-1:0]count_store,
output wire reset_sys
);

wire [$clog2(`ROW_M)-1:0]index_i;
wire [$clog2(`ROW_M)-1:0]index_j;
wire [$clog2(`ROW_M)-1:0]index_k;
wire [$clog2(`ROW_M)-1:0]index_ii_a;
wire [$clog2(`COL_M)-1:0]index_jj_a;
wire [$clog2(`ROW_N)-1:0]index_ii_w;
wire [$clog2(`COL_N)-1:0]index_jj_w;

//wire load_a;
//wire load_w;

 ram#(
`include "config_sys.vh"
)ram(

.clk(clk),
.load_a(load_a),
.load_w(load_w),
.deload_out(deload_out),
.addr_a(addr_a),
.addr_w(addr_w),
.addr_res(addr_res),
.a(a),
.w(w),
.out(out),
.test_en(test_en),
.test_data(test_data)
);




 vpu_top#(
`include "config_sys.vh"
) top(
.clk(clk),
.reset(reset),
.start(start),
.load_a(load_a),
.load_w(load_w),
.deload_out(deload_out),
//input wire deload,
//input wire deload_out,
//input wire [$clog2(`ROW_M)-1:0]index_a1,
//input wire [$clog2(`COL_M)-1:0]index_a2,
//input wire [$clog2(`ROW_N)-1:0]index_w1,
//input wire [$clog2(`COL_N)-1:0]index_w2,
//input wire start,
.a(a),
.w(w),
.out(out),
//output wire [`DATA_WIDTH*`ROW_A-1:0]a_in,
//output wire [`WEIGHT_WIDTH*`COL_W-1:0]w_in,
//output wire [`ROW_A-1:0]johnson_count,
.addr_a(addr_a),
.addr_w(addr_w),
.addr_res(addr_res),
.compute(compute),
.index_i(index_i),
.index_j(index_j),
.index_k(index_k),
.index_ii_a(index_ii_a),
.index_jj_a(index_jj_a),
.index_ii_w(index_ii_w),
.index_jj_w(index_jj_w),
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


endmodule

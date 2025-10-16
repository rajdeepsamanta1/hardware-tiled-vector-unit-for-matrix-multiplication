`include "config_sys.vh"

module vpu_top(
input wire clk,
input wire reset,
input wire start,
output wire load_a,
output wire load_w,
output wire deload_out,
//input wire deload,
//input wire deload_out,
//input wire [$clog2(`ROW_M)-1:0]index_a1,
//input wire [$clog2(`COL_M)-1:0]index_a2,
//input wire [$clog2(`ROW_N)-1:0]index_w1,
//input wire [$clog2(`COL_N)-1:0]index_w2,
//input wire start,
input wire [`BUS_WIDTH-1:0]a,
input wire [`BUS_WIDTH-1:0]w,
output wire [`OUT_WIDTH*`ROW_A-1:0]out,
//output wire [`DATA_WIDTH*`ROW_A-1:0]a_in,
//output wire [`WEIGHT_WIDTH*`COL_W-1:0]w_in,
//output wire [`ROW_A-1:0]johnson_count,
output wire [`ADDR_WIDTH-1:0]addr_a,
output wire [`ADDR_WIDTH-1:0]addr_w,
output wire [`ADDR_WIDTH-1:0]addr_res,
output wire compute,
output wire [$clog2(`ROW_M)-1:0]index_i,
output wire [$clog2(`ROW_M)-1:0]index_j,
output wire [$clog2(`ROW_M)-1:0]index_k,
output wire [$clog2(`ROW_M)-1:0]index_ii_a,
output wire [$clog2(`COL_M)-1:0]index_jj_a,
output wire [$clog2(`ROW_N)-1:0]index_ii_w,
output wire [$clog2(`COL_N)-1:0]index_jj_w,
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

assign out1=out[15:0];
assign out2=out[31:16];
assign out3=out[47:32];
assign out4=out[63:48];



wire [`DATA_WIDTH*`ROW_A-1:0]a_in;
wire [`WEIGHT_WIDTH*`COL_W-1:0]w_in;
wire [`ROW_A-1:0]johnson_count;
//wire load_a;
//wire load_w;
//wire deload;
//wire deload_out;

/*

sys_controller #(
`include "config_sys.vh"
)controller(
.clk(clk),
.reset(reset),
.start(start),
.index_a1(index_a1),
.index_a2(index_a2),
.index_w1(index_w1),
.index_w2(index_w2),
.a_addr(a_addr),
.w_addr(w_addr),
.load_a(load_a),
.load_w(load_w),
.deload(deload),
.deload_out(deload_out)
);

*/


//wire load_a;
//wire load_w;
//wire deload;
//wire deload_out;
//wire reset_sys;
//wire store;
//wire compute;

vpu_controller#(
`include "config_sys.vh"
)controller(
.clk(clk),
.reset(reset),
.start(start),
.compute(compute),
.load_a(load_a),
.load_w(load_w),
.deload(deload),
.deload_out(deload_out),
.reset_sys(reset_sys),
.store(store)
);

//wire [$clog2(`ROW_M):0]index_i;
//wire [$clog2(`COL_M):0]index_j;
//wire [$clog2(`ROW_N):0]index_k;




vpu_tiling#(
`include "config_sys.vh"
)tiling(
.clk(clk),
.reset(reset),
.compute(compute),
.index_i(index_i),
.index_j(index_j),
.index_k(index_k),
.done(done)
);

/*


index_gen#(
`include "config_sys.vh"
)index_gen(
.clk(clk),
.reset(reset),
.load_a(load_a),
.load_w(load_w),
.index_i_a(index_i_a),
.index_j_a(index_j_a),
.index_i_w(index_i_w),
.index_j_w(index_j_w)
);

*/

//wire [$clog2(`ROW_M)-1:0]index_i_a;
//wire [$clog2(`COL_M)-1:0]index_j_a;
//wire [$clog2(`ROW_N)-1:0]index_i_w;
//wire [$clog2(`COL_N)-1:0]index_j_w;
//output reg [$clog2(`ROW_M)-1:0]index_ii_a,
//output reg [$clog2(`COL_M)-1:0]index_jj_a,
//output reg [$clog2(`ROW_N)-1:0]index_ii_w,
//output reg [$clog2(`COL_N)-1:0]index_jj_w
//wire [`ADDR_WIDTH-1:0]addr_a;
//wire [`ADDR_WIDTH-1:0]addr_w;


vpu_addr_gen #(
`include "config_sys.vh"
) addr_gen (
.clk(clk),
.reset(reset),
.load_a(load_a),
.load_w(load_w),
.deload_out(deload_out),
.index_i(index_i),
.index_j(index_j),
.index_k(index_k),
//.index_j_w(index_j_w),
.index_ii_a(index_ii_a),
.index_jj_a(index_jj_a),
.index_ii_w(index_ii_w),
.index_jj_w(index_jj_w),
.addr_a(addr_a),
.addr_w(addr_w),
.addr_res(addr_res)
);

//wire [$clog2(`ROW_A)-1:0]count_deload_a;
//wire [$clog2(`ROW_A)-1:0]count_deload_w;



vpu_deload #(
`include "config_sys.vh"
)controller_deload(
.clk(clk),
.reset(reset),
.deload(deload),
.count_deload_a(count_deload_a),
.count_deload_w(count_deload_w)

    );




vpu_load#(

`include "config_sys.vh"
) regfile(
.clk(clk),
.reset(reset),
.load_a(load_a),
.load_w(load_w),
.deload(deload),
.johnson_count(johnson_count),
.a(a), 
.w(w),
.a_in(a_in),
.w_in(w_in),
.count_deload_a(count_deload_a),
.count_deload_w(count_deload_w)

);



vpu_matmul #(

`include "config_sys.vh"
)matmul(
    .clk(clk), 
    .deload_out(deload_out),
    .reset(reset),
    .reset_sys(reset_sys),
    .compute_done(compute_done),
    .a_in(a_in), 
    .w_in(w_in), 
    .out(out),
    .deload(deload),
    .store(store),
    .sum(sum),
    .mult_in(mult_in),
    .count_store(count_store)
);







endmodule

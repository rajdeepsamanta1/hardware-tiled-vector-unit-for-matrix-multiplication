`include "config_sys.vh"

module vpu_addr_gen(
input wire clk,
input wire reset,
input wire load_a,
input wire load_w,
input wire deload_out,
input wire [$clog2(`ROW_M):0]index_i,
input wire [$clog2(`COL_M):0]index_j,
input wire [$clog2(`ROW_N):0]index_k,
//input wire [$clog2(`COL_N):0]index_j_w,
output reg [$clog2(`ROW_M)-1:0]index_ii_a,
output reg [$clog2(`COL_M)-1:0]index_jj_a,
output reg [$clog2(`ROW_N)-1:0]index_ii_w,
output reg [$clog2(`COL_N)-1:0]index_jj_w,
output wire [`ADDR_WIDTH-1:0]addr_a,
output wire [`ADDR_WIDTH-1:0]addr_w,
output wire [`ADDR_WIDTH-1:0]addr_res
);

reg load_a_buff1;
reg load_w_buff1;

reg load_a_buff2;
reg load_w_buff2;

reg deload_buff1;


// reg [$clog2(`ROW_M):0]index_ii_a;
// reg [$clog2(`COL_M):0]index_jj_a;
// reg [$clog2(`ROW_N):0]index_ii_w;
// reg [$clog2(`COL_N):0]index_jj_w;
 
 reg [$clog2(`ROW_M)-1:0]index_ii_res;
 reg [$clog2(`ROW_M)-1:0]index_jj_res;
 
 assign addr_res = `C_ADDR + index_ii_res*`COL_N + index_jj_res;
 
 
assign addr_a = `A_ADDR+index_ii_a*`COL_M  + index_jj_a; 
assign addr_w = `W_ADDR+index_ii_w*`COL_N  + index_jj_w; 


always @(posedge clk)
begin
     load_a_buff1<=load_a;
     load_w_buff1<=load_w;
     
     load_a_buff2<=load_a_buff1;
     load_w_buff2<=load_w_buff1;
     
     deload_buff1<=deload_out;
end



always @(posedge clk)
begin
     if(load_a_buff1==0 && load_a==1)
     begin       
          index_ii_a<=index_i;
          index_jj_a<=index_k;
     end
     
     
     else if(load_a_buff1==1 && load_a==1)
     begin           
          index_jj_a<=index_jj_a+1;
     end
     
     else
     begin
          index_jj_a<=0;
     end              


     if(load_w_buff1==0 && load_w==1)
     begin       
          index_ii_w<=index_k;
          index_jj_w<=index_j;
     end
     
     
     else if(load_w_buff1==1 && load_w==1)
     begin           
          index_ii_w<=index_ii_w+1;
     end
     
     else
     begin
          index_ii_w<=0;
     end 
     
     
     if(deload_out==1 && deload_buff1==0)
     begin
          index_ii_res<=index_i;
          index_jj_res<=index_j;
     end
     
     else if(deload_out==1 && deload_buff1==1)
     begin
          index_ii_res<=index_ii_res+1;
          
     end  
     
     else
         index_ii_res<=0;           
end



endmodule

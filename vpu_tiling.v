`include "config_sys.vh"

module vpu_tiling(
input wire clk,
input wire reset,
input wire compute,
output reg [$clog2(`ROW_M)-1:0]index_i,
output reg [$clog2(`ROW_M)-1:0]index_j,
output reg [$clog2(`ROW_M)-1:0]index_k,
output reg done);

reg compute_buff;


always@(posedge clk)
begin
     if(reset)
     compute_buff<=0;
     
     else
     if(compute==1)
     compute_buff<=1;
end


always @(posedge clk)
begin
     
     
     if(reset)
     begin
          index_i<=0;
          index_j<=0;
          index_k<=0;
          done<=0;
     end
     
     else
     begin
          if(compute==1 && compute_buff==1)
          index_k<=index_k+`ROW_A;
          
          if(compute==1 && index_k==`ROW_M-`ROW_A)
          begin
               index_k<=0;
               index_j<=index_j+`ROW_A;
          end
          
          if(compute==1 && index_j==`ROW_M-`ROW_A && index_k==`ROW_M-`ROW_A)
          begin
               index_j<=0;
               index_i<=index_i+`ROW_A;
          end
          
          if(index_i==`ROW_M-`ROW_A && index_j==`ROW_M-`ROW_A && index_k==`ROW_M-`ROW_A)
          done<=1;
            
     
     end
end

         

endmodule

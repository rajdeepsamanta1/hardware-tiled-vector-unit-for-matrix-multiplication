`include "config_sys.vh"

module vpu_deload(
input wire clk,
input wire reset,
input wire deload,
output reg [$clog2(`ROW_A)-1:0]count_deload_a,
output reg [$clog2(`ROW_A)-1:0]count_deload_w

    );
    
always @(posedge clk)
begin
     if(reset)
     begin
          count_deload_a<=0;
          count_deload_w<=0;
     end
     
     else
     begin
          if(deload)
          begin
               count_deload_w<=count_deload_w+1;
               
               if(count_deload_w == `ROW_A-1)
               begin
                    count_deload_w<=0;
                    count_deload_a<=count_deload_a+1;
               end
          end
     end
end


endmodule

`include "config_sys.vh"

module vpu_controller(
input wire clk,
input wire reset,
input wire start,
output reg compute,
output reg load_a,
output reg load_w,
output reg deload,
output reg deload_out,
output reg reset_sys,
output reg store
);

reg [31:0]count;

reg [31:0]count_tile;

always @(posedge clk)
begin
     if(reset)
     count_tile<=0;
     
     else
     if(compute==1)
     count_tile<=count_tile+1;
end


always @(posedge clk)
begin
     if(reset)
     begin
          load_a<=0;
          load_w<=0;
          deload<=0;
          deload_out<=0;
          count<=0;
          compute<=0;
          reset_sys<=0;
     end
     
     
     else
     begin
          if(start)
          begin
               count<=count+1;
               
               if(count==1)
               compute<=1;
               
               else
               compute<=0;
               
               if(count>=2 && count<=`COL_A+1)
               begin
                    load_a<=1;
                   
               end
               
               else
               load_a<=0;
               
               if(count>=`COL_A+2 && count<=`COL_A+`ROW_W+1)
               begin
                    load_w<=1;
                  
               end
               
               else
               load_w<=0;
               
               if(count>=`COL_A+`ROW_W+3 && count<=`ROW_A +`COL_A+2+`ROW_A*`ROW_A)
               deload<=1;
               
               else
               deload<=0;
               
               if(count>=`COL_A+`ROW_W+3+$clog2(`ROW_A)+3 && count<=`ROW_A +`COL_A+2+`ROW_A*`ROW_A + $clog2(`ROW_A) + 3)
               store<=1;
               
               else
               store<=0;
               
               
             //  if(count>=`ROW_A+`COL_A+2+`ROW_A*`ROW_A+$clog2(`ROW_A)+1 && count<=`ROW_A +`COL_A+2+`ROW_A*`ROW_A+$clog2(`ROW_A)+`ROW_A+4 && count_tile%(`COL_M/`COL_A)==0)
             //  deload_out<=1;
             
               if(count>=`ROW_A+`COL_A+2+`ROW_A*`ROW_A+$clog2(`ROW_A)+4 && count<=`ROW_A +`COL_A+2+`ROW_A*`ROW_A+$clog2(`ROW_A)+`ROW_A+3 && count_tile % ( `COL_N/`COL_A)==0 )
               deload_out<=1;
               
               else
               deload_out<=0;
               
             //  if(count==`ROW_A +`COL_A+2+`ROW_A*`ROW_A+$clog2(`ROW_A)+`ROW_A+5 && count_tile%(`COL_N/`COL_A)==0)
             //  reset_sys<=1;
             
              if(count==`ROW_A +`COL_A+2+`ROW_A*`ROW_A+$clog2(`ROW_A)+`ROW_A+5 && count_tile % ( `COL_N/`COL_A)==0 )
              reset_sys<=1;
               
               else
               reset_sys<=0;
               
               if(count==`ROW_A +`COL_A+2+2*`ROW_A+2*`ROW_A+40)
               count<=0;
         end
     end
end



endmodule

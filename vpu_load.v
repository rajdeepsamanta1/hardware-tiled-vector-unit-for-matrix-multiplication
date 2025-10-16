`include "config_sys.vh"

module vpu_load(
input wire clk,
input wire reset,
//input wire reset_sys,
input wire load_a,
input wire load_w,
input wire deload,
input wire [`ROW_A-1:0]johnson_count,
input wire  [`BUS_WIDTH -1:0] a, 
input wire  [`BUS_WIDTH -1:0] w,
output reg [`DATA_WIDTH*`ROW_A-1:0]a_in,
output reg [`WEIGHT_WIDTH*`COL_W-1:0]w_in,
input wire [$clog2(`ROW_A)-1:0]count_deload_a,
input wire [$clog2(`ROW_A)-1:0]count_deload_w

);

reg load_a_load_buff1;
reg load_a_load_buff2;
reg load_a_load_buff3;
reg load_a_load_buff4;

reg load_w_load_buff1;
reg load_w_load_buff2;
reg load_w_load_buff3;
reg load_w_load_buff4;

always @(posedge clk)
begin
     load_a_load_buff1<=load_a;
     load_a_load_buff2<=load_a_load_buff1;
     load_a_load_buff3<=load_a_load_buff2;
     load_a_load_buff4<=load_a_load_buff3;
     
     load_w_load_buff1<=load_w;
     load_w_load_buff2<=load_w_load_buff1;
     load_w_load_buff3<=load_w_load_buff2;
     load_w_load_buff4<=load_w_load_buff3;
end



// input matrix to store entire a matrix

reg [`DATA_WIDTH-1:0]a_mem[0:`ROW_A-1][0:`COL_A-1];
reg [`WEIGHT_WIDTH-1:0]w_mem[0:`ROW_W-1][0:`COL_W-1];




// local regfiles for storing a and w tile after double buffering



// counters for loading data into regfile

reg [$clog2(`COL_A)-1:0]cnt_a;
reg [$clog2(`ROW_W)-1:0]cnt_w;


genvar k;

generate

for(k=0; k<`ROW_A; k=k+1)
begin
     always @(posedge clk)
     begin
          if(load_a_load_buff2==1)
          begin
               a_mem[k][cnt_a]<=a[`DATA_WIDTH*(k+1)-1:`DATA_WIDTH*k];
          end
          
          if(load_w_load_buff2==1)
          begin
               w_mem[cnt_w][k]<=w[`WEIGHT_WIDTH*(k+1)-1:`WEIGHT_WIDTH*k];
          end
     end
end

endgenerate
 

// loading input matrix to input registers 


always @(posedge clk)
begin
     if(reset)
     begin
          cnt_a<=0;
          cnt_w<=0;
     end
     
     else
     begin
     
          if(load_a_load_buff2)
          begin
              //a_mem[cnt_a/`COL_A][cnt_a%`COL_A]<=a;
              cnt_a<=cnt_a+1;
          end
          
          else
          cnt_a<=0;
     
     
          if(load_w_load_buff2)
          begin
               //w_mem[cnt_w/`COL_W][cnt_w%`COL_W]<=w;
               cnt_w<=cnt_w+1;
          end
          
          else
          cnt_w<=0;
          
       end

end

 

  
  // deloading ports of a and w matrix


//reg [($clog2(`COL_A))-1:0]count_deload;

/*

genvar i;
generate


  for (i = 0; i < `ROW_A; i = i + 1) begin : a_loop
    always @(posedge clk) begin
      if (deload==1) begin
        a_in[`DATA_WIDTH*(i+1)-1 : `DATA_WIDTH*(i)] <= a_mem[i][count_deload];
        w_in[`WEIGHT_WIDTH*(i+1)-1 : `WEIGHT_WIDTH*(i)] <= w_mem[count_deload][i];
       // count_deload<=count_deload+1;
      end else begin
        a_in[`DATA_WIDTH*(i+1)-1 : `DATA_WIDTH*(i)] <= 0;
        w_in[`WEIGHT_WIDTH*(i+1)-1 : `WEIGHT_WIDTH*(i)] <= 0;
        //count_deload<=0;
      end
    end
  end


endgenerate

*/


reg [($clog2(`COL_A))-1:0]count_deload[0:`ROW_A-1];

reg deload_buff_load;

always @(posedge clk)
begin
     deload_buff_load<=deload;
end



genvar i;
generate


  for (i = 0; i < `ROW_A; i = i + 1) begin : a_loop
    always @(posedge clk) begin
      if (deload_buff_load==1) begin
        a_in[`DATA_WIDTH*(i+1)-1 : `DATA_WIDTH*(i)] <= a_mem[count_deload_a][i];
        w_in[`WEIGHT_WIDTH*(i+1)-1 : `WEIGHT_WIDTH*(i)] <= w_mem[i][count_deload_w];
       
      end else begin
        a_in[`DATA_WIDTH*(i+1)-1 : `DATA_WIDTH*(i)] <= 0;
        w_in[`WEIGHT_WIDTH*(i+1)-1 : `WEIGHT_WIDTH*(i)] <= 0;
        
      end
    end
  end


endgenerate


endmodule


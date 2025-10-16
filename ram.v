`include "config_sys.vh"

module ram(input wire clk,
input wire load_a,
input wire load_w,
input wire deload_out,
input wire [`ADDR_WIDTH-1:0]addr_a,
input wire [`ADDR_WIDTH-1:0]addr_w,
input wire [`ADDR_WIDTH-1:0]addr_res,
output reg [`BUS_WIDTH-1:0]a,
output reg [`BUS_WIDTH-1:0]w,
input wire [`BUS_WIDTH-1:0]out,
input wire test_en,
output reg [`DATA_WIDTH-1:0]test_data
);


reg [`DATA_WIDTH-1:0]fifo[0:1023];

reg load_a1;
reg load_a2;

reg load_w1;
reg load_w2;

reg deload_buff;

reg [`ADDR_WIDTH-1:0]test_addr=`C_ADDR;

always @(posedge clk)
begin
     if(test_en)
     begin
     test_data<=fifo[test_addr];
     test_addr<=test_addr+1;
     end
end

integer b;

always @(posedge clk)
begin
     if(test_en)
     begin
          for(b=512; b<768; b=b+1)
          begin
               $display("%d ", fifo[b]);
              
          end
     end
end

always @(posedge clk)
begin
     load_a1<=load_a;
     load_a2<=load_a1;
    
     
     load_w1<=load_w;
     load_w2<=load_w1;
     
     deload_buff<=deload_out;
    
end


initial
begin
     $readmemb("/D/rajdeep_projects/project_2/project_2.srcs/sim_1/new/matrix_ab_binary.txt", fifo);
end

genvar i;

generate

for(i=0; i<`ROW_A; i=i+1)
begin

always @(posedge clk)
begin 
     if(load_a1)
     begin
          a[`DATA_WIDTH*(i+1)-1:`DATA_WIDTH*i]<=fifo[addr_a+i*`COL_M];
     end
     
     if(load_w1)
     begin
          w[`DATA_WIDTH*(i+1)-1:`DATA_WIDTH*i]<=fifo[addr_w+i];
     end
          
end

end

endgenerate



genvar j;

generate

for(j=0; j<`ROW_A; j=j+1)
begin

always @(posedge clk)
begin 
     if(deload_buff)
     begin
          fifo[addr_res+j]<=out[`DATA_WIDTH*(j+1)-1:`DATA_WIDTH*j];
     end
     
          
end

end

endgenerate

   
endmodule

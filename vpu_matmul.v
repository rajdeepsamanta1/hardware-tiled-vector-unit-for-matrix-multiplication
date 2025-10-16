`include "config_sys.vh"

module vpu_matmul(
    input wire clk, 
    input wire deload_out,
    input wire reset,
    input wire reset_sys,
    input wire compute_done,
    input wire [`DATA_WIDTH*`ROW_A-1:0] a_in, 
    input wire [`WEIGHT_WIDTH*`COL_W-1:0]w_in, 
    output reg [`OUT_WIDTH*`ROW_A-1:0]out,
    input wire deload,
    input wire store,
    output wire [`DATA_WIDTH-1:0]sum,
    output reg [`WEIGHT_WIDTH*`COL_W-1:0]mult_in ,
    output reg [$clog2(`ROW_A*`ROW_A)-1:0]count_store 
);


 //reg [`WEIGHT_WIDTH*`COL_W-1:0]mult_in;
 
 genvar i;
 
 generate
 
 for(i=0; i<`COL_W; i=i+1)
 begin
      always @(posedge clk)
      begin
           mult_in[`DATA_WIDTH*(i+1)-1:`DATA_WIDTH*i]<=a_in[`DATA_WIDTH*(i+1)-1:`DATA_WIDTH*i] * w_in[`DATA_WIDTH*(i+1)-1:`DATA_WIDTH*i];
      end
end

endgenerate

//wire [`DATA_WIDTH-1:0]sum;

vpu_addertree #(

`include "config_sys.vh"

)addertree(
    .clk(clk),
    .rst(reset),
    .in_flat(mult_in), // Flattened array of inputs
    .out(sum)
);



  
    wire [`DATA_WIDTH-1:0]a_out[`ROW_A-1:0][`COL_W-1:0];
    wire [`WEIGHT_WIDTH-1:0]w_out[`ROW_A-1:0][`COL_W-1:0];
    reg [`DATA_WIDTH+`WEIGHT_WIDTH-1:0] res[`ROW_A-1:0][`COL_W-1:0]; 
    //reg  [`DATA_WIDTH+`WEIGHT_WIDTH-1:0] res_buff[`ROW_A-1:0][`COL_W-1:0]; 
    

// the entire grid is generated
// the array consisting of rows and column are stacked
// they can operate concurrently on different tiles


    
 // double buffering the resultant matrix
 
 /*genvar a,b,c;
 
 generate
 
   
            for (b = 0; b < `ROW_A; b = b + 1) 
            begin 
                for (c = 0; c <`COL_W; c = c + 1) 
                begin
                     always @(posedge clk)
                     begin
                       if(compute_done==1)
                       res_buff[b][c]<=res[b][c];
                       end
                end
            end
        
        
    endgenerate
    
    */
    
   //reg [$clog2(`ROW_A*`ROW_A)-1:0]count_store;
    
   integer k, j;

always @(posedge clk)
begin
     if(reset)
     count_store<=1;
     
     if(reset_sys==1 || reset==1)
     begin
          for(k=0; k<`ROW_A; k=k+1)
          begin
               for(j=0; j<`COL_W; j=j+1)
               begin
                    res[k][j]<=0;
               end
          end
      end
     
     
     if(store)
     begin
          res[count_store/`ROW_A][count_store%`ROW_A]<=res[count_store/`ROW_A][count_store%`ROW_A]+sum;
          count_store<=count_store+1;
     end
end
        
 
 
 reg [$clog2(`COL_W)-1:0]output_cnt;  
    
  // deloading output matrix
  
  genvar a;
  
  generate
  
  for(a=0; a<`ROW_A; a=a+1)
  begin
       
       always @(posedge clk)
       begin
            if(deload_out==1)
            out[`OUT_WIDTH*(a+1)-1:`OUT_WIDTH*a]<=res[output_cnt][a];
            
            
            
            else
            out<=0;
       end 
   end
   
   endgenerate  




always @(posedge clk)
begin
    if(reset)
    output_cnt<=0;
    
    else
    if(deload_out==1)
    output_cnt<=output_cnt+1;
    
    else
    output_cnt<=0;
end
  


endmodule


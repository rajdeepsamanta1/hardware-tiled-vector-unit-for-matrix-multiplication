`include "config_sys.vh"

module vpu_addertree(

    input  wire clk,
    input  wire rst,
    input  wire [`VLEN-1:0] in_flat, // Flattened array of inputs
    output wire [`SEW  - 1:0] out
);

    
    localparam STAGES = $clog2(`VLEN/`SEW);

    // 2D array for each stage
    wire [`SEW - 1:0] stage [0:STAGES][0:`VLEN/`SEW-1];

    genvar i, s;

    // -------- Stage 0: Load inputs --------
    generate
        for (i = 0; i < `VLEN/`SEW; i = i + 1) begin : LOAD_INPUTS
            assign stage[0][i] = in_flat[i*`SEW +: `SEW];
        end
    endgenerate

    // -------- Pipeline: Perform pairwise addition at each stage --------
    generate
        for (s = 0; s < STAGES; s = s + 1) begin : PIPELINE_STAGE
            for (i = 0; i < `VLEN/`SEW >> (s+1); i = i + 1) begin : ADD_PAIRS
                reg [`SEW  - 1:0] sum;
                always @(posedge clk) begin
                    if (rst)
                        sum <= 0;
                    else
                        sum <= stage[s][2*i] + stage[s][2*i + 1];
                end
                assign stage[s+1][i] = sum;
            end
        end
    endgenerate

    // -------- Final output --------
    assign out = stage[STAGES][0];



endmodule


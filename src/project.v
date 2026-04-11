`default_nettype none

module tt_um_pro_clk (
    input  wire [7:0] ui_in,    
    output wire [7:0] uo_out,   
    input  wire [7:0] uio_in,   
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       ena,      
    input  wire       clk,      
    input  wire       rst_n     
);

    // =========================
    // Input Mapping
    // =========================
    wire [3:0] radix = ui_in[3:0];   // 1–9
    wire [1:0] scale = ui_in[5:4];   // scale control

    // =========================
    // Output
    // =========================
    wire clk_out;

    // =========================
    // Instantiate your module
    // =========================
    tt_um_prog_clk core (
        .clk(clk),
        .rst_n(rst_n),
        .radix(radix),
        .scale(scale),
        .clk_out(clk_out)
    );

    // =========================
    // Output Mapping
    // =========================
    assign uo_out[0] = clk_out;

    // unused outputs = 0
    assign uo_out[7:1] = 7'b0;

    // =========================
    // Unused IOs
    // =========================
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule

`default_nettype wire

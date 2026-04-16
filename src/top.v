`default_nettype none

module tt_um_prog_clk (
    input  wire        clk,        // 50 MHz
    input  wire        rst_n,      // active-low reset

    input  wire [3:0]  radix,      // 1-9
    input  wire [1:0]  scale,      // 00:kHz, 01:10kHz, 10:100kHz, 11:MHz

    output reg         clk_out
);

    // =========================
    // Combinational N (next value)
    // =========================
    reg [15:0] N_next;

    always @(*) begin
        case (scale)

            2'd0: begin
                case (radix)
                    4'd1: N_next = 25000;
                    4'd2: N_next = 12500;
                    4'd3: N_next = 8333;
                    4'd4: N_next = 6250;
                    4'd5: N_next = 5000;
                    4'd6: N_next = 4167;
                    4'd7: N_next = 3571;
                    4'd8: N_next = 3125;
                    4'd9: N_next = 2778;
                    default: N_next = 25000;
                endcase
            end

            2'd1: begin
                case (radix)
                    4'd1: N_next = 2500;
                    4'd2: N_next = 1250;
                    4'd3: N_next = 833;
                    4'd4: N_next = 625;
                    4'd5: N_next = 500;
                    4'd6: N_next = 417;
                    4'd7: N_next = 357;
                    4'd8: N_next = 313;
                    4'd9: N_next = 278;
                    default: N_next = 2500;
                endcase
            end

            2'd2: begin
                case (radix)
                    4'd1: N_next = 250;
                    4'd2: N_next = 125;
                    4'd3: N_next = 83;
                    4'd4: N_next = 62;
                    4'd5: N_next = 50;
                    4'd6: N_next = 42;
                    4'd7: N_next = 36;
                    4'd8: N_next = 31;
                    4'd9: N_next = 28;
                    default: N_next = 250;
                endcase
            end

            2'd3: begin
                case (radix)
                    4'd1: N_next = 25;
                    4'd2: N_next = 12;
                    4'd3: N_next = 8;
                    4'd4: N_next = 6;
                    4'd5: N_next = 5;
                    4'd6: N_next = 4;
                    4'd7: N_next = 3;
                    4'd8: N_next = 3;
                    4'd9: N_next = 2;
                    default: N_next = 25;
                endcase
            end

        endcase
    end

    // =========================
    // Registered N (SAFE)
    // =========================
    reg [15:0] N_reg;

    // =========================
    // Counter
    // =========================
    reg [15:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_out <= 0;
            N_reg   <= 25000;  // default 1 kHz
        end else begin

            // ? Safe update ONLY at boundary
            if (counter == 0) begin
                N_reg <= N_next;
            end

            // Counter operation
            if (counter == (N_reg-1)) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1;
            end

        end
    end

endmodule

`default_nettype wire

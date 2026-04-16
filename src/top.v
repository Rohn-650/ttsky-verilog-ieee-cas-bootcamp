`default_nettype none

module tt_um_prog_clk (
    input  wire        clk,        // 50 MHz
    input  wire        rst_n,      // active-low reset

    input  wire [3:0]  radix,      // 1-9
    input  wire [1:0]  scale,      // 00:100Hz, 01:1kHz, 10:10kHz, 11:100kHz

    output reg         clk_out
);

    // =========================
    // Combinational N (next value)
    // fout = 50MHz / (2 x N)
    // =========================
    reg [17:0] N_next;

    always @(*) begin
        case (scale)

            // --------------------------------------------------
            // Scale 00 -> 100 Hz range
            // --------------------------------------------------
            2'd0: begin
                case (radix)
                    4'd1: N_next = 18'd250000;   // 100 Hz
                    4'd2: N_next = 18'd125000;   // 200 Hz
                    4'd3: N_next = 18'd83333;    // 300 Hz
                    4'd4: N_next = 18'd62500;    // 400 Hz
                    4'd5: N_next = 18'd50000;    // 500 Hz
                    4'd6: N_next = 18'd41667;    // 600 Hz
                    4'd7: N_next = 18'd35714;    // 700 Hz
                    4'd8: N_next = 18'd31250;    // 800 Hz
                    4'd9: N_next = 18'd27778;    // 900 Hz
                    default: N_next = 18'd250000;
                endcase
            end

            // --------------------------------------------------
            // Scale 01 -> 1 kHz range
            // --------------------------------------------------
            2'd1: begin
                case (radix)
                    4'd1: N_next = 18'd25000;    // 1 kHz
                    4'd2: N_next = 18'd12500;    // 2 kHz
                    4'd3: N_next = 18'd8333;     // 3 kHz
                    4'd4: N_next = 18'd6250;     // 4 kHz
                    4'd5: N_next = 18'd5000;     // 5 kHz
                    4'd6: N_next = 18'd4167;     // 6 kHz
                    4'd7: N_next = 18'd3571;     // 7 kHz
                    4'd8: N_next = 18'd3125;     // 8 kHz
                    4'd9: N_next = 18'd2778;     // 9 kHz
                    default: N_next = 18'd25000;
                endcase
            end

            // --------------------------------------------------
            // Scale 10 -> 10 kHz range
            // --------------------------------------------------
            2'd2: begin
                case (radix)
                    4'd1: N_next = 18'd2500;     // 10 kHz
                    4'd2: N_next = 18'd1250;     // 20 kHz
                    4'd3: N_next = 18'd833;      // 30 kHz
                    4'd4: N_next = 18'd625;      // 40 kHz
                    4'd5: N_next = 18'd500;      // 50 kHz
                    4'd6: N_next = 18'd417;      // 60 kHz
                    4'd7: N_next = 18'd357;      // 70 kHz
                    4'd8: N_next = 18'd312;      // 80 kHz
                    4'd9: N_next = 18'd278;      // 90 kHz
                    default: N_next = 18'd2500;
                endcase
            end

            // --------------------------------------------------
            // Scale 11 -> 100 kHz range
            // --------------------------------------------------
            2'd3: begin
                case (radix)
                    4'd1: N_next = 18'd250;      // 100 kHz
                    4'd2: N_next = 18'd125;      // 200 kHz
                    4'd3: N_next = 18'd83;       // 300 kHz
                    4'd4: N_next = 18'd62;       // 400 kHz
                    4'd5: N_next = 18'd50;       // 500 kHz
                    4'd6: N_next = 18'd42;       // 600 kHz
                    4'd7: N_next = 18'd36;       // 700 kHz
                    4'd8: N_next = 18'd31;       // 800 kHz
                    4'd9: N_next = 18'd28;       // 900 kHz
                    default: N_next = 18'd250;
                endcase
            end

            default: N_next = 18'd250000;

        endcase
    end

    // =========================
    // Registered N (SAFE)
    // =========================
    reg [17:0] N_reg;

    // =========================
    // Counter
    // =========================
    reg [17:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 18'd0;
            clk_out <= 1'b0;
            N_reg   <= 18'd250000;   // default 100 Hz
        end else begin

            // Safe update ONLY at half-period boundary
            if (counter == 18'd0) begin
                N_reg <= N_next;
            end

            // Counter + toggle
            if (counter == (N_reg - 18'd1)) begin
                counter <= 18'd0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 18'd1;
            end

        end
    end

endmodule

`default_nettype wire

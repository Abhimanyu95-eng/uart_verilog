module uartTX #(
    parameter clk_freq = 1000000,
    parameter baud_rate = 9600)(
    input clk, reset,
    input send, 
    input [7:0] data_in,
    output reg tx_line,
    output reg busy);

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;
    
    reg [7:0] bit_count;
    reg [1:0] state;
    wire baud_tick;
    reg [7:0] shift_reg;
    
    baud_generator #( .clk_freq(clk_freq), .baud_rate(baud_rate))
    baud_gen (.clk(clk), .reset(reset), .baud_tick(baud_tick));
    
    always@(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            bit_count <= 0;
            busy <= 0;
            tx_line <= 1'b1;
        end
        else begin
            case(state) 
                IDLE : begin
                    busy <= 0;
                    tx_line <= 1'b1;
                    
                    if (send) begin
                        shift_reg <= data_in;
                        state <= START;
                        tx_line <= 1'b0; 
                        busy <= 1'b1;
                    end
                end
                
                START : begin
                    if (baud_tick) begin
                        state <= DATA;
                        bit_count <= 0;
                    end
                end 
                DATA : begin
                    tx_line <= shift_reg[0];
                    if (baud_tick) begin
                        shift_reg <= {1'b0, shift_reg[7:1]};
                        if (bit_count == 7) begin
                            state <= STOP;
                        end
                        else begin
                        bit_count <= bit_count + 1;
                        end
                    end
                end
                STOP : begin
                    tx_line <= 1'b1;
                    if(baud_tick) begin
                        state <= IDLE;
                        busy <= 1'b0;
                    end
                end
            endcase
        end
    end
endmodule

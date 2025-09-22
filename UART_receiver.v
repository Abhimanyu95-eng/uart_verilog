module uartRX # (parameter clk_freq = 1000000,
parameter baud_rate = 9600)(
    input clk, reset,
    input rx_line, 
    output reg [7:0] data_out,
    output reg data_ready );
    
    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;
    
    reg [7:0] bit_count;
    reg [1:0] state;
    wire baud_tick;
    reg [7:0] shift_reg;
    
    baud_generator #(.clk_freq(clk_freq), .baud_rate(baud_rate)) 
    baud_gen (.clk(clk), .reset(reset), .baud_tick(baud_tick));
    
    reg rx_sync, rx_prev; 
    
    always@(posedge clk) begin
        if( reset) begin
            rx_sync <= 1'b1;
            rx_prev <= 1'b1;
        end
        else begin
            rx_sync <= rx_line;
            rx_prev <= rx_sync;
        end
    end 
    
    always@(posedge clk) begin
        if(reset) begin
            bit_count <= 0;
            shift_reg <= 0;
            state <= IDLE;
            data_out <= 0;
            data_ready <= 0; end
            
        else begin 
            case(state)
                IDLE : begin
                     data_ready <= 1'b0;
                     
                     if (rx_prev && !rx_sync) begin
                         state <= START;
                     end
                end
                
                START : begin
                    if (baud_tick) begin
                        if (!rx_sync) begin 
                            state <= DATA;
                            bit_count <= 0;
                        end
                        else begin
                            state <= IDLE;
                        end
                    end
                end
                
                DATA : begin
                    if (baud_tick) begin
                        shift_reg <= {rx_sync, shift_reg[7:1]};
                        if (bit_count == 7) begin
                            state <= STOP; 
                        end
                        else begin
                            bit_count <= bit_count + 1;
                        end
                    end
                end
                
                STOP : begin
                    if (baud_tick) begin
                        if(rx_sync) begin
                            data_out <= shift_reg;
                            data_ready <= 1'b1;
                        end
                            state <= IDLE;
                    end
                end
            endcase
        end
     end
endmodule


module baud_generator #(
    parameter clk_freq = 1000000,
    parameter baud_rate = 9600)(
    input clk, reset,
    output reg baud_tick);
    
    localparam COUNTMAX = (clk_freq / baud_rate) - 1;
    reg [15:0] counter;
    
    always@(posedge clk) begin
        if (reset) begin    
            counter <= 0;
            baud_tick <= 0;
        end
        else if (counter >= COUNTMAX) begin
            counter <= 0;
            baud_tick <= 1;
        end
        else begin 
            counter <= counter + 1;
            baud_tick <= 0;
        end
    end
endmodule

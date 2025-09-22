module uart_top # (parameter clk_freq = 1000000,
parameter baud_rate = 9600)(input clk, reset,
    input [7:0] tx_data, 
    input tx_send, 
    output reg tx_line, 
    output reg tx_busy,
    
    input rx_line,
    output reg [7:0] rx_data,
    output reg rx_ready
    );
    
    uartTX #(.clk_freq(clk_freq), .baud_rate(baud_rate)) tx_unit (.clk(clk), .reset(reset)
    ,.send(tx_send), .data_in(tx_data), .busy(tx_busy), .tx_line(tx_line) );
    
     uartRX #(.clk_freq(clk_freq), .baud_rate(baud_rate)) rx_unit (.clk(clk), .reset(reset),
     .rx_line(rx_line), .data_out(rx_data), .data_ready(rx_ready));

endmodule

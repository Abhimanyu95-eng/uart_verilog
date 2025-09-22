module uart_tb;
    reg clk, reset;
    reg [7:0] tx_data;
    reg tx_send;
    wire tx_busy, tx_line;
    wire [7:0] rx_data;
    wire rx_ready;

    uart_top #(.clk_freq(1000000), .baud_rate(9600))
    uart_dut (
        .clk(clk), .reset(reset),
        .tx_data(tx_data), .tx_send(tx_send), 
        .tx_busy(tx_busy), .tx_line(tx_line),
        .rx_line(tx_line), 
        .rx_data(rx_data), .rx_ready(rx_ready)
    );
     
    initial begin
        clk = 0;
        forever #500 clk = ~clk; // 500ns + 500ns = 1000ns = 1us period
    end
    

    time tx_start_time, tx_end_time, rx_ready_time;
    
    initial begin
        $dumpfile("uart_tb.vcd");
        $dumpvars(0, uart_tb); 
        
        // Initialize
        reset = 1;
        tx_send = 0;
        tx_data = 0;
        
        // Reset
        #5000;
        reset = 0;
        #5000;
        
      
        $display("Time %0t: Sending 0x55 (01010101b)", $time);
        tx_data = 8'h55;
        tx_start_time = $time;
        tx_send = 1;
        #1000;         
        tx_send = 0;
        
        wait(!tx_busy);
        tx_end_time = $time;
        $display("Time %0t: TX completed (Duration: %0t ns)", $time, tx_end_time - tx_start_time);
        
        wait(rx_ready);
        rx_ready_time = $time;
        $display("Time %0t: RX received 0x%02h (Total time: %0t ns)", $time, rx_data, rx_ready_time - tx_start_time);
        
        if (rx_data == 8'h55)
            $display("✓ SUCCESS: Loopback test 1 passed!");
        else
            $display("✗ FAIL: Expected 0x55, got 0x%02h", rx_data);

      
        #50000; // Wait a bit
        $display("\nTime %0t: Sending 0xAA (10101010b)", $time);
        tx_data = 8'hAA;
        tx_start_time = $time;
        tx_send = 1;
        #1000;
        tx_send = 0;
        
        wait(!tx_busy);
        wait(rx_ready);
        rx_ready_time = $time;
        $display("Time %0t: RX received 0x%02h (Total time: %0t ns)", $time, rx_data, rx_ready_time - tx_start_time);
        
        if (rx_data == 8'hAA)
            $display("✓ SUCCESS: Loopback test 2 passed!");
        else
            $display("✗ FAIL: Expected 0xAA, got 0x%02h", rx_data);
            
        
        #50000;
        $display("\nTime %0t: Sending 0x00 (00000000b)", $time);
        tx_data = 8'h00;
        tx_send = 1;
        #1000;
        tx_send = 0;
        
        wait(!tx_busy);
        wait(rx_ready);
        $display("Time %0t: RX received 0x%02h", $time, rx_data);
        
        if (rx_data == 8'h00)
            $display("✓ SUCCESS: All zeros test passed!");
        else
            $display("✗ FAIL: Expected 0x00, got 0x%02h", rx_data);
            
        // Test 4: Send 0xFF (all ones)
        #50000;
        $display("\nTime %0t: Sending 0xFF (11111111b)", $time);
        tx_data = 8'hFF;
        tx_send = 1;
        #1000;
        tx_send = 0;
        
        wait(!tx_busy);
        wait(rx_ready);
        $display("Time %0t: RX received 0x%02h", $time, rx_data);
        
        if (rx_data == 8'hFF)
            $display("✓ SUCCESS: All ones test passed!");
        else
            $display("✗ FAIL: Expected 0xFF, got 0x%02h", rx_data);
        
        #100000;
        $display("\n=== Test Summary ===");
        $display("All UART loopback tests completed!");
        $display("Expected frame time: %0t ns (10 bits @ 9600 baud)", 10000000/96); // ~104.17us
        $finish;
    end
    
    
    always @(posedge tx_send) begin
        $display("Time %0t: Starting transmission of 0x%02h", $time, tx_data);
    end
    
    always @(negedge tx_line) begin
        $display("Time %0t: TX start bit detected on tx_line", $time);
    end
    
    always @(posedge rx_ready) begin
        $display("Time %0t: RX data ready: 0x%02h", $time, rx_data);
    end
    
    // Monitor busy signal transitions
    always @(posedge tx_busy) begin
        $display("Time %0t: TX busy asserted", $time);
    end
    
    always @(negedge tx_busy) begin
        $display("Time %0t: TX busy released", $time);
    end
    
endmodule

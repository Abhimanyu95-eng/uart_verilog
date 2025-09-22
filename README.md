
# UART Communication in Verilog

## Overview
This project implements a **Universal Asynchronous Receiver/Transmitter (UART)** in **Verilog HDL**. It includes a **transmitter (TX)**, **receiver (RX)**, and a **baud rate generator**, allowing 8-bit data to be transmitted and received serially. The design has been **verified through simulation**.

---

## Features
- Fully **parameterized**: clock frequency and baud rate can be configured.  
- Supports **8N1 UART format** (8 data bits, no parity, 1 stop bit).  
- **TX Module**: Sends data serially on the `tx_line`.  
- **RX Module**: Receives serial data from `rx_line` and outputs a `data_ready` signal.  
- **Baud Rate Generator**: Produces precise timing ticks for UART communication.  
- Modular and reusable design suitable for integration in larger FPGA projects.  

---

## Modules
1. **`uart_top.v`** – Top-level module connecting TX, RX, and baud generator.  
2. **`uartTX.v`** – UART transmitter module.  
3. **`uartRX.v`** – UART receiver module.  
4. **`baud_generator.v`** – Generates baud ticks based on clock frequency and desired baud rate.  
5. **`testbench.v`** – Simulation testbench to verify the UART functionality.  

---

## How It Works
- **Transmission (TX)**: Data to be sent is loaded into the transmitter, which serializes it with a start bit, 8 data bits (LSB first), and a stop bit.  
- **Reception (RX)**: The receiver detects the start bit, samples incoming bits at the correct baud rate, and asserts `data_ready` when a full byte is received.  
- **Baud Rate Generator**: Divides the system clock to generate timing ticks matching the configured baud rate.  

---

## Simulation
- The design has been **simulated successfully** using Verilog simulators like **Vivado** or **ModelSim**.  
- Testbenches include sending and receiving sample bytes and verifying `data_out` and `data_ready` signals.  

---


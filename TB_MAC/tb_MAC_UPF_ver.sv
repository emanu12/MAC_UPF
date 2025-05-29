`timescale 1ns/1ps
module tb_MAC_UPF_ver;
import UPF::*;

localparam int unsigned NBITS = 8;

logic [NBITS-1:0] inputs_tb;  
logic [NBITS-1:0] weights_tb;
logic [2*NBITS-1:0] out_tb;
logic clk;
logic reset;
logic enable;
logic [2:0] state_select;
bit status0, status1, status2, status3, status4, status5;

// Istanziazione del modulo sotto test
MAC_UPF UUT( 
    .inputs(inputs_tb),
    .weights(weights_tb),
    .clk(clk),
    .reset(reset),
    .state_select(state_select),
    .outputs(out_tb)
);

// Generatore di clock
always #2 clk = ~clk;

// Stimolo degli input
always@(posedge clk) begin
    if (enable) begin
        assign_inputs(inputs_tb, weights_tb);
    end
end

// Blocco iniziale
initial begin 
    enable = 0;
    reset = 1;
    clk = 1;
    inputs_tb = 8'b00000000;
    weights_tb = 8'b00000000;
    state_select = 3'b000;

    status0 = supply_on("UUT/VddML", 0.0);
    status1 = supply_on("UUT/VddMH", 0.0);
    status2 = supply_on("UUT/VddAH", 0.0);
    status3 = supply_on("UUT/VddAL", 0.0);
    status4 = supply_on("UUT/Vss",   0.0);
    status5 = supply_on("UUT/Vback", 1.2);

    #3 
    enable = 1;
    reset = 0;

    // RPM
    state_select = 3'b001;
    status0 = supply_on("UUT/VddML", 0.8);
    status1 = supply_on("UUT/VddMH", 0.0);
    status2 = supply_on("UUT/VddAH", 0.0);
    status3 = supply_on("UUT/VddAL", 0.8);
    status4 = supply_on("UUT/Vss",   0.0);
    status5 = supply_on("UUT/Vback", 1.2);
    #10;

    enable = 0; #2 enable = 1;

    // LPM
    state_select = 3'b011;
    status0 = supply_on("UUT/VddML", 0.8);
    status1 = supply_on("UUT/VddMH", 0.0);
    status2 = supply_on("UUT/VddAH", 1.2);
    status3 = supply_on("UUT/VddAL", 0.0);
    status4 = supply_on("UUT/Vss",   0.0);
    status5 = supply_on("UUT/Vback", 1.2);
    #10;

    enable = 0; #2 enable = 1;

    // ESm
    state_select = 3'b010;
    status0 = supply_on("UUT/VddML", 0.0);
    status1 = supply_on("UUT/VddMH", 1.2);
    status2 = supply_on("UUT/VddAH", 0.0);
    status3 = supply_on("UUT/VddAL", 0.8);
    status4 = supply_on("UUT/Vss",   0.0);
    status5 = supply_on("UUT/Vback", 1.2);
    #10;

    enable = 0; #2 enable = 1;

    // FPM
    state_select = 3'b110;
    status0 = supply_on("UUT/VddML", 0.0);
    status1 = supply_on("UUT/VddMH", 1.2);
    status2 = supply_on("UUT/VddAH", 0.0);
    status3 = supply_on("UUT/VddAL", 1.2);
    status4 = supply_on("UUT/Vss",   0.0);
    status5 = supply_on("UUT/Vback", 1.2);

    #10 $finish;
end

// Task per assegnare input random
task assign_inputs(output logic [NBITS-1:0] inputs, output logic [NBITS-1:0] weights);
    begin
        inputs = $urandom_range(0, 100);
        weights = $urandom_range(0, 100);
    end
endtask

endmodule

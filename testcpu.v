`timescale  1ns / 1ps
`include "cpu.v"
module tb_cpu;

// cpu Parameters
parameter PERIOD  = 10;
// cpu Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 1 ;

// cpu Outputs
wire  [31:0]  debug_wb_pc                  ;
wire  debug_wb_rf_wen                      ;
wire  [4 :0]  debug_wb_rf_addr             ;
wire  [31:0]  debug_wb_rf_wdata            ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD) rst  =  0;
end

cpu  u_cpu (
    .clk                     ( clk                       ),
    .rst                     ( rst                       ),

    .debug_wb_pc             ( debug_wb_pc        [31:0] ),
    .debug_wb_rf_wen         ( debug_wb_rf_wen           ),
    .debug_wb_rf_addr        ( debug_wb_rf_addr   [4 :0] ),
    .debug_wb_rf_wdata       ( debug_wb_rf_wdata  [31:0] )
);

initial
begin
    $monitor("%h,%d,%h,%d",debug_wb_pc,debug_wb_rf_wen,debug_wb_rf_addr,debug_wb_rf_wdata);
	$dumpfile("cpu.vcd");
	$dumpvars(0,tb_cpu);
    #10000

    $finish;
end

endmodule
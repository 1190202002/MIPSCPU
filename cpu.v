`timescale 1ns / 1ps
`include "PC.v"
`include "regfile.v"
`include "controlUnit.v"
`include "insMemory.v"
`include "dataMemory.v"
`include "alu.v"
module cpu (
    input            clk             ,  // clock, 100MHz
    input            rst             ,  // active high, board switch 0 (SW0)

    // debug signals
    output [31:0]    debug_wb_pc     ,   // 当前正在执行指令的PC
    output           debug_wb_rf_wen ,   // 当前通用寄存器组的写使能信号
    output [4 :0]    debug_wb_rf_addr,   // 当前通用寄存器组写回的寄存器编号
    output [31:0]    debug_wb_rf_wdata   // 当前指令需要写回的数据
);  
    wire [31:0] rsdata,rtdata,DAddr,DataIn,wdata,result,pc;
    wire [5:0]  func,op;
    wire [4:0] rs,rt,rd,waddr;
    wire [15:0] offset;
    wire [25:0] instr;
    wire WR,BEQZ,Regwen;
    wire [31:0] DataOut;
    // reg debug_wb_pc,debug_wb_rf_addr,debug_wb_rf_wdata,debug_wb_rf_wen;
    assign DAddr=rsdata+{{16{offset[15]}},offset};
    assign DataIn=rtdata;                            //写往数据存储器的数据
    assign waddr=(op==6'b000000) ? rd:rt;           //要写回的寄存器编号，rd，rt
    assign wdata=(op==6'b000000) ? result:DataOut;//要写回到通用寄存器，运算结果或内存数�
    assign BEQZ=(rsdata==rtdata);
    assign WR = (op== 6'b101011) ;
    assign Regwen=((op==6'b000000 & func!=6'b001010) | (op==6'b000000 & func==6'b001010 & rt==0) |op==6'b100011 );
	 assign debug_wb_rf_wen=Regwen;
    assign debug_wb_pc=(Regwen==1) ? pc:debug_wb_pc;
    assign debug_wb_rf_addr=(Regwen==1) ? waddr:debug_wb_rf_addr;
    assign debug_wb_rf_wdata=(Regwen==1) ? wdata:debug_wb_rf_wdata;
    // initial begin
    //     debug_wb_pc=pc;
    //     debug_wb_rf_addr=0;
    //     debug_wb_rf_wdata=0;
    //     debug_wb_rf_wen=0;
    // end
    // always @(posedge clk) begin
    //   if(rst==0)begin
    //     if(Regwen==1) begin
    //       debug_wb_pc=pc;
    //       debug_wb_rf_addr=waddr;
    //       debug_wb_rf_wdata=wdata;
    //       debug_wb_rf_wen=Regwen;
    //     end
    //   end
    //   else begin
    //     debug_wb_pc=pc;
    //     debug_wb_rf_addr=waddr;
    //     debug_wb_rf_wdata=wdata;
    //     debug_wb_rf_wen=Regwen;
    //   end
        // else begin
        //   debug_wb_pc=pc;
        //   debug_wb_rf_addr=0;
        //   debug_wb_rf_wdata=0;
        //   debug_wb_rf_wen=0;
        // end
    // end
alu  u_alu (
    .rsdata                  ( rsdata   ),
    .rtdata                  ( rtdata   ),
    .func                    ( func     ),

    .result                  ( result   )
);
dataMemory  u_dataMemory (
    .clk                      (clk       ),
    .DAddr                   ( DAddr     ),
    .DataIn                  ( DataIn    ),
    .WR                      ( WR        ),

    .DataOut                 ( DataOut   )
);
insMemory  u_insMemory (
    .pc                      ( pc   ),

    .op                      ( op            ),
    .instr_index             ( instr         ),
    .rs                      ( rs            ),
    .rt                      ( rt            ),
    .rd                      ( rd            ),
    .offset                  ( offset        ),
    .func                    ( func          )
);
PC  u_PC (
    .clk                     ( clk      ),
    .rst                     ( rst      ),
    .BEQZ                    ( BEQZ     ),
    .op                      ( op       ),
    .offset                  ( offset   ),
    .instr                   ( instr    ),

    .pc                      ( pc )
);  
regfile  u_regfile (
    .clk                      (clk),
    .rs                      ( rs       ),
    .rt                      ( rt       ),
    .Regwen                  ( Regwen ),
    .waddr                   ( waddr),
    .wdata                   ( wdata),

    .rsdata                  ( rsdata   ),
    .rtdata                  ( rtdata   )
);
    


endmodule


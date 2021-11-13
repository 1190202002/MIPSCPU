`timescale 1ns / 1ps

module PC(
     input clk, rst,  
     input BEQZ,
     input [5:0]  op, 
     input [15:0] offset,  
     input [25:0] instr,
     output reg [31:0] pc
);
     
     always @(posedge clk )  
         begin  
              if (rst == 1) begin  
                    pc = -4;    
                end  
                else  begin  
                    pc = pc + 4;  // 跳转到下一指令 
                    if (op==6'b000010)   pc={pc[31:28],instr,2'b00};          //JUMP
                    else if (op==6'b000100 && BEQZ )  pc = {{14{offset[15]}},offset,2'b00}+pc;  // BEQZ
                end  
          end  

endmodule  

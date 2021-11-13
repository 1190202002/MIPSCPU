//根据PC从指令存储器取出对应指令
`timescale 1ns / 1ps
module dataMemory(
    // 根据数据通路图定义输入和输出
    input  clk,
    input [31:0] DAddr,
    input [31:0] DataIn,
    input WR,
    output [31:0] DataOut
    );
     // 实验要求：指令存储器和数据存储器存储单元宽度一律使��
     // 所以将一�2位的数据拆成4�位的存储器单元存�
     // ��位存储器恢复�2位存储器
     reg [31:0] datamemory[255:0];       //256×32位指令缓冲存储器
     initial begin
       $readmemh("lab2.data/lab2_data_data",datamemory,0,255);
     end
        
         assign DataOut = datamemory[DAddr/4];
        
         // write data  
         always @(posedge clk )  
             begin  
                  if (WR == 1) begin
                      datamemory[DAddr/4]<=DataIn;
                  end  
             end  
endmodule

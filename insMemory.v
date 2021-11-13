//根据PC从指令存储器取出对应指令
`timescale 1ns / 1ps

module insMemory (
    // 根据数据通路图定义输入和输出
    input [31:0] pc,   
    output [5:0] op,
    output [25:0] instr_index,
    output [4:0] rs, rt, rd,  
    output [15:0] offset,
    output [5:0] func
    );

    // 实验要求：指令存储器和数据存储器存储单元宽度一律使用8位
    // 所以将一个32位的指令拆成4个8位的存储器单元存储
    // 从文件取出后将他们合并为32位的指令
    reg [31:0] irmem[255:0];
    wire [31:0] instruction;
    initial begin
        $readmemh("./lab2.data/lab2_inst_data", irmem,0,255); // 从文件中读取指令二进制代码赋值给mem
        // instruction = 0; // 指令初始化
    end

    // always @(pc) begin
    //     instruction = irmem[pc/4];
         
    // end
    // output  
    assign instruction=irmem[pc/4];
    assign  op = instruction[31:26];  
    assign rs = instruction[25:21];  
    assign    rt = instruction[20:16];  
    assign    rd = instruction[15:11];  
    assign    offset = instruction[15:0];
    assign    func = instruction[5:0];
    assign    instr_index=instruction[25:0];
    

endmodule 
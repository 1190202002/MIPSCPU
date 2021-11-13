//alu运算模块,算术运算均有符号
`define ADD  6'b100000   
`define SUB  6'b100010   
`define AND  6'b100100
`define OR   6'b100101
`define XOR  6'b100110
`define SLT  6'b101010
`define MOV  6'b001010 


module alu(
    input[31:0] rsdata,
    input[31:0] rtdata,
    input[5:0]  func, 
    output[31:0] result
);
    wire [31:0]    add_result;
    wire [31:0]    sub_result;
    wire [31:0]    and_result;
    wire [31:0]    or_result;
    wire [31:0]    xor_result;
    wire           slt_result;
    wire  [31:0]   mov_result;  
    assign add_result=rsdata+rtdata;
    assign sub_result=rsdata-rtdata;
    assign and_result=rsdata&rtdata;
    assign or_result=rsdata|rtdata;
    assign xor_result=rsdata^rtdata;
    assign slt_result=(rsdata<rtdata);
    assign mov_result=rsdata;
    assign  result = ({32{func == `ADD}}  & add_result)  |
                    ({32{func == `SUB}}  & sub_result)  |
                    ({32{func == `AND}}  & and_result)  |
                    ({32{func == `OR}}  & or_result)  |
                    ({32{func == `XOR}}  & xor_result)  |
                    ({32{func == `SLT}}  & {{31{1'b0}},slt_result}) |
                    ({32{func == `MOV}} & mov_result)  ;
                    
    

endmodule
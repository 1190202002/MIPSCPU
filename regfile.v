//通用寄存器，r0~r31，r0恒为0
module regfile(
    input clk,
    // READ PORT 1
    input  [4 :0] rs,
    output [31:0] rsdata,
    // READ PORT 2
    input  [4 :0] rt,
    output [31:0] rtdata,
    // WRITE PORT
    input         Regwen   ,   //write enable, active high
    input  [4 :0] waddr ,
    input  [31:0] wdata
);
    reg [31:0] rf [31:0];

    // initial with $readmemh is synthesizable here
    initial begin
        $readmemh("lab2.data/lab2_reg_data", rf,0,31);
    end

    //WRITE
    always @(posedge clk) begin
        if (Regwen==1 && |waddr) begin    // don't write to $0
            rf[waddr] <= wdata;
        end
    end

    //READ OUT 1
    assign rsdata = (rs == 5'b0) ? 32'b0 : rf[rs];

    //READ OUT 2
    assign rtdata = (rt == 5'b0) ? 32'b0 : rf[rt];

endmodule
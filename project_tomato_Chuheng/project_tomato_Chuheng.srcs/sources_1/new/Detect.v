`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/23 22:41:31
// Design Name: 
// Module Name: Detect
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Detect(
    input sig,clk,rst,
    output flag
    );
    reg sig_reg0;
    reg sig_reg1;
    always@(posedge clk or posedge rst)
    if(rst)begin
    sig_reg0<=0;
    sig_reg1<=0;
    end
    else begin
    sig_reg0<=sig;
    sig_reg1<=sig_reg0;
    end
    assign flag = sig_reg0 & (~sig_reg1);
endmodule

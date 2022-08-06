`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/24 08:34:26
// Design Name: 
// Module Name: Read
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


module Read(
    input clk,rst_n,
    input cnt_en,load,
    input key_cut,
    input [7:0]x1,
    input [7:0]x2,
    output [7:0]x7,
    output  [7:0]x8
    );
    reg [7:0] cut1 [0:4];//记录数  5个8位寄存器    
    reg [7:0] cut2 [0:4];//记录数  5个8位寄存器  
    reg [7:0]x_7;
    reg [7:0]x_8;
    reg[3:0] k;
    reg[3:0] rk;
    
   initial begin k = 0;rk=0; cut1[0]=0;cut1[1]=0;cut1[2]=0;cut1[3]=0;cut1[4]=0;
                             cut2[0]=0;cut2[1]=0;cut2[2]=0;cut2[3]=0;cut2[4]=0;end
   
    always@(posedge clk or posedge rst_n or posedge cnt_en or posedge load)
    begin 
        if ((rst_n )||( cnt_en == 0 && load == 1)) //&& pausedelay == 1)//清零
           begin k = 0;rk = 0; x_7 = 0;x_8 = 0;cut1[0]=0;cut1[1]=0;cut1[2]=0;cut1[3]=0;cut1[4]=0;
                             cut2[0]=0;cut2[1]=0;cut2[2]=0;cut2[3]=0;cut2[4]=0; end

        else if(cnt_en == 1 && load == 0 )//计数
        begin
            x_7 = 0;x_8 = 0;
            if(k < 4)
            begin
                if (key_cut == 1)
                begin
                    cut1[k] = x1;
                    cut2[k] = x2;
                    k <= k+1;
                end
            end
         end
        else if(cnt_en == 1 && load == 1 )//读数
        begin 
           if (key_cut == 1)
                begin
                    x_7 <= cut1[rk];
                    x_8 <= cut2[rk];
                    rk = rk + 1;
                    if(rk == 4) rk <= 0;
                end 
        end
    end
    
     //转BCD 
    assign x8 = x_8 ;
    assign x7 = x_7 ;
   
endmodule

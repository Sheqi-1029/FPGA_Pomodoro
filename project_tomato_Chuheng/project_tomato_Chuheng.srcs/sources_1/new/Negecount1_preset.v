`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/24 02:27:46
// Design Name: 
// Module Name: Negecount1_preset
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


module Negecount1_preset(
    input clk,
    input pulse_in,
    input rst_n,
    input[7:0] preset,
    input upset,
    input downset,
    input cnt_en,load,//pausedelay,
    output wire[7:0]x//BCD码计数
    );
    wire[3:0] x1;//个位
    wire[3:0] x2;//十位
    reg[4:0] xn;//计数
    parameter Xx = 25;//计数
    
//    initial begin
//    xn = preset;
//   end
   
    //计数
    always@(posedge pulse_in or posedge rst_n or posedge cnt_en or posedge load)
    begin 
         //计数
        if ((rst_n )||( cnt_en == 0 && load == 1))
            xn <= preset;
        else if (cnt_en == 1 && load == 0)
        begin
            if(pulse_in)//高电平
           begin
               if(xn == 0)
                   xn <= 0;
                else
                    xn <= xn - 1;
            end
            
        end
        //暂停
        else if (cnt_en == 0 && load == 0 )//&& pausedelay == 0)
            xn <= xn;
            
    end
    
     //转BCD 
    assign x1 = xn % 10;
    assign x2 = (xn - x1) / 10;
    assign x = x1 + (x2 << 4);
endmodule

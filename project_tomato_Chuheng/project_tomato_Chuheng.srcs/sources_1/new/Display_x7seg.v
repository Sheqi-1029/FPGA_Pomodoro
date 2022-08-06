`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/23 20:55:31
// Design Name: 
// Module Name: Display_x7seg
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


module Display_x7seg(
    input clk,
    input rst_n,//模式使能
    input wire[7:0] x1,
    input wire[7:0] x2,
    output reg [6:0] a_to_g,//段信号
    output reg [7:0] an //位选信号 
    );
    wire [31:0]x;
    assign x = (x2 << 8) + x1;
    
    //clkdiv:时钟分频计数器
     reg[20:0] clkdiv;
     always @(posedge clk or posedge rst_n)
     begin
        if(rst_n)
            clkdiv <= 21'd0;
        else 
            clkdiv <= clkdiv + 1;
     end
     //bitcnt:位扫描
     wire [1:0]bitcnt;
     assign bitcnt  = clkdiv[20:19];
     
     //an：位选信号产生
     always @* begin
        if(rst_n) an = 4'b0;
        else
            case(bitcnt)
                2'd0:an=4'b0001;
                2'd1:an=4'b0010;
                2'd2:an=4'b0100;
                2'd3:an=4'b1000;     
                default:an=4'd0;
             endcase
     end
     //digit :当前显示数字
     reg [3:0]digit;
     always @*begin
        if(rst_n)
            digit = 4'd0;
        else 
        case (bitcnt)
            2'd0:digit = x[3:0];
            2'd1:digit = x[7:4];
            2'd2:digit = x[11:8];
            2'd3:digit = x[15:12];
            default : digit = 4'd0;
        endcase
     end
     
     //a_to_g:段码信号
     always @(*)begin
     if(rst_n)
        a_to_g = 7'b1111111;
     else
        case (digit)
        0:a_to_g = 7'b1111110;
        1:a_to_g = 7'b0110000;
        2:a_to_g = 7'b1101101;
        3:a_to_g = 7'b1111001;
        4:a_to_g = 7'b0110011;
        5:a_to_g = 7'b1011011;
        6:a_to_g = 7'b1011111;
        7:a_to_g = 7'b1110000;
        8:a_to_g = 7'b1111111;
        9:a_to_g = 7'b1111011;
        default:a_to_g = 7'b1111110;        
     endcase   
    end
    
endmodule

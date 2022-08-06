`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/24 06:53:52
// Design Name: 
// Module Name: Preset_num
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


module Preset_num(
    input clk,rst,
    input cnt_en,load,
    input upset,
    input downset,
    output wire[7:0] setnum
    );
    
    parameter Xx = 25;
    reg[7:0] set_n;
    
    initial begin
       set_n = 25;
    end
    
    always@(posedge rst or posedge clk)
    begin
        if(rst)
            set_n = Xx;
        else begin
        if ( cnt_en == 0 && load == 1)
            begin
                if(upset == 1) set_n <= set_n + 1;
                else if(downset == 1) set_n <= set_n - 1;
                else set_n <= set_n;
            end
         if (( cnt_en == 1 && load == 0)||( cnt_en == 0 && load == 0))
            set_n <= set_n;
        end 
     end 
  
     assign  setnum = set_n; 
    
endmodule

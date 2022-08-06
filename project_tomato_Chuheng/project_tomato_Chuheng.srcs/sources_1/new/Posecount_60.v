 module Posecount_60( 
    input clk,
    input pulse_in,
    input rst_n,
    input cnt_en,load,//pausedelay,
    output wire borrow,//传25脉冲
    output wire[7:0]x//BCD码计数
    );
    
    wire[3:0] x1;//个位
    wire[3:0] x2;//十位
    reg[5:0] xn;//计数
    reg up;
    parameter Xx = 60;//计数
    
    initial begin
    xn = 0;
    up = 1'b0;
    end
    
    //计数
    always@(posedge pulse_in or posedge rst_n)
    begin 
         //计数
        if ((rst_n )||( cnt_en == 0 && load == 1))// && pausedelay == 1))
            xn <= 0;
        //计数
        else if (cnt_en == 1 && load == 0)// && pausedelay == 1)
        begin
            if(pulse_in)//高电平
            begin
                if(xn == Xx - 1)
                    xn <= 0;
                else
                    xn <= xn + 1;
            end
        end
        //暂停
        else if ((cnt_en == 0 && load == 0 )
             ||(cnt_en == 1 && load == 1 ))//&& pausedelay == 0)
            xn <= xn;
        
        if ((xn == Xx - 1) & (rst_n == 0))
            up = 1'b1;
        else
            up = 1'b0;
            
    end
    
    assign borrow = up;
    
     //转BCD 
    assign x1 = xn % 10;
    assign x2 = (xn - x1) / 10;
    assign x = x1 + (x2 << 4);
     
endmodule
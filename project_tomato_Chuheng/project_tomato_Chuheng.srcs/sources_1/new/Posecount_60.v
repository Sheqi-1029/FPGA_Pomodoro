 module Posecount_60( 
    input clk,
    input pulse_in,
    input rst_n,
    input cnt_en,load,//pausedelay,
    output wire borrow,//��25����
    output wire[7:0]x//BCD�����
    );
    
    wire[3:0] x1;//��λ
    wire[3:0] x2;//ʮλ
    reg[5:0] xn;//����
    reg up;
    parameter Xx = 60;//����
    
    initial begin
    xn = 0;
    up = 1'b0;
    end
    
    //����
    always@(posedge pulse_in or posedge rst_n)
    begin 
         //����
        if ((rst_n )||( cnt_en == 0 && load == 1))// && pausedelay == 1))
            xn <= 0;
        //����
        else if (cnt_en == 1 && load == 0)// && pausedelay == 1)
        begin
            if(pulse_in)//�ߵ�ƽ
            begin
                if(xn == Xx - 1)
                    xn <= 0;
                else
                    xn <= xn + 1;
            end
        end
        //��ͣ
        else if ((cnt_en == 0 && load == 0 )
             ||(cnt_en == 1 && load == 1 ))//&& pausedelay == 0)
            xn <= xn;
        
        if ((xn == Xx - 1) & (rst_n == 0))
            up = 1'b1;
        else
            up = 1'b0;
            
    end
    
    assign borrow = up;
    
     //תBCD 
    assign x1 = xn % 10;
    assign x2 = (xn - x1) / 10;
    assign x = x1 + (x2 << 4);
     
endmodule
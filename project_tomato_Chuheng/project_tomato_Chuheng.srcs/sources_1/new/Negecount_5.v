module Negecount_5(
    input clk,
    input pulse_in,
    input rst_n,
    input cnt_en,load,//pausedelay,
    output wire[7:0]x,//BCD�����
    output wire finish_delay
    );
    wire[3:0] x1;//��λ
    wire[3:0] x2;//ʮλ
    reg[4:0] xn;//����
    reg finish_del;
    parameter Xx = 6;//����
    reg[4:0] sign_xn;
    
    initial begin
        finish_del = 1;
         xn = Xx;sign_xn = Xx-1;
    end
    
//    always @(posedge clk or posedge rst_n)
//    if (rst_n ) 
//       finish_del = 1;
//    else if (( xn != Xx)||(cnt_en == 0 && load == 0 ))
//       finish_del = 0;
    
    //����
    always@(posedge pulse_in or posedge rst_n)
    begin 
        if ((rst_n )||( cnt_en == 0 && load == 1) //&& pausedelay == 1)
        ||( cnt_en == 1 && load == 0 ))//&& pausedelay == 1))
        begin xn = Xx;sign_xn = Xx-1;end
        //����
        else if(cnt_en == 0 && load == 0 )//&& pausedelay == 0)
        begin
            //finish_del = 0;
//            if (xn == Xx) xn = Xx - 1;
//            else begin
                if(pulse_in)//�ߵ�ƽ
                begin
                  if(xn == 0)
                       begin xn = 0;end
                   else
                       begin 
                       xn = xn - 1;
                       end
                end
                sign_xn = xn - 2;
//            end
        end
        
        if ((xn == 0) & (rst_n == 0))//&(sec == 0)
            finish_del <= 1'b1;
        else
            finish_del <= 1'b0;
            
    end
    
     //תBCD 
    assign x1 = sign_xn % 10;
    assign x2 = (sign_xn - x1) / 10 ;
    assign x = x1 + (x2 << 4);
    assign finish_delay = finish_del;
endmodule
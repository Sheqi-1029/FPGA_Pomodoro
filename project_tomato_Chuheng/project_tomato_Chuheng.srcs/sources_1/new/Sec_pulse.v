module Sec_pulse(
     input clk,
     input rst_n,
     output wire sec_pulse
    );
    parameter Mm=1000000;//分频总计数1MHz
    reg [27:0] m;//计数
    reg up;
    
    initial begin
    m = 28'b0;
    up = 1'b0;
    end
    
    //时钟计数
    always @(posedge clk or posedge rst_n)
    begin
        if (rst_n)
            m <= 0;
        else if(rst_n==0)
             begin
                 if (m == Mm -1) m <= 0;
                 else m <= m + 1;
              end
    end
    
    //脉冲
    always @(posedge clk or posedge rst_n)
    begin
        if ((m == Mm -1) & (rst_n == 0))
            up <= 1'b1;
        else
            up <= 1'b0;
    end
    assign sec_pulse = up;
      
endmodule

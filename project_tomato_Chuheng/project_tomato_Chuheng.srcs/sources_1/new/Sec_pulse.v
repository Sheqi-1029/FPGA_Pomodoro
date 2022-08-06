module Sec_pulse(
     input clk,
     input rst_n,
     output wire sec_pulse
    );
    parameter Mm=1000000;//��Ƶ�ܼ���1MHz
    reg [27:0] m;//����
    reg up;
    
    initial begin
    m = 28'b0;
    up = 1'b0;
    end
    
    //ʱ�Ӽ���
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
    
    //����
    always @(posedge clk or posedge rst_n)
    begin
        if ((m == Mm -1) & (rst_n == 0))
            up <= 1'b1;
        else
            up <= 1'b0;
    end
    assign sec_pulse = up;
      
endmodule

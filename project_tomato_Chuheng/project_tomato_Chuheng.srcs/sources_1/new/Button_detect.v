module Button_detect(
    input clk,
    input rst_n,
    input key,
    output reg key_value
    );
    reg key_reg,delay_cnt;
    always@(posedge clk,posedge rst_n)
    if(rst_n)
    key_reg<=1'b0;
    else
    key_reg<=key;
    always@(posedge clk,posedge rst_n)
    if(rst_n)
    delay_cnt<=21'b0;
    else if(key!=key_reg)
    //delay_cnt=21'd1500000;
    delay_cnt=21'd15;
    else if(delay_cnt>0)
    delay_cnt<=delay_cnt-1'b1;
    else
    delay_cnt<=21'd0;
    always@(posedge clk,posedge rst_n)
    if(rst_n)
    key_value<=1'b0;
    else if(delay_cnt==1'b1)
    key_value<=key;
    else
    key_value<=key_value;

endmodule

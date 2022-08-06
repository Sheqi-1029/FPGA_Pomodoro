module Main_tomato(
    input clk,
    input mod_con,//状态控制
    input mod_con1,//状态1 reset控制
    input mod_con2,//状态2 reset控制
    //mod1 - mod2
    input key_1,//Reset
    input key_2,//Pause - stop
    input key_3,//预置加 - cut 
    input key_4,//预置减 - 上翻
    
    output wire [7:0] led,// LED灯信号
    output wire [6:0] a_to_g1,//段信号
    output wire [3:0] an1, //位选信号 
    output wire [6:0] a_to_g2,//段信号
    output wire [3:0] an2 //位选信号
    );
    //significant fastor begin
    wire rstmod;
    wire[31:0] x;//待显示输出数据
    parameter Mod1 = 0,Mod2 = 1;//模式选择
    wire x_reg;//待显示输出数据寄存
    wire enable_mod;//模式使能
    wire sig_1,sig_2,sig_3,sig_4;
    wire val_1,val_2,val_3,val_4;
    //mod 1
    wire finish_delay;
    wire sec_pulse, borrow1,borrow2;
    wire[7:0] preset;
    wire[7:0] x1;//60计数
    wire[7:0] x2;//set计数
    wire[7:0] x3;//60计数
    wire[7:0] x4;//5计数
    wire cnt_en,load;//,pausedelay;//状态量
    //mod 2
    wire sec_pulse2,borrow3;
    wire [2:0] cut_num;//按秒表次数
    wire [63:0] cut;//记录数
    wire[7:0] x5;//60计数
    wire[7:0] x6;//min计数
    wire[7:0] x7;//00计数
    wire[7:0] x8;//序号计数 
    wire cnt_en2,load2;//,pausedelay;//状态量
    wire[7:0] preset2;
    //significant fastor end
   
   assign rstmod = (enable_mod == Mod1)? mod_con1 : mod_con2;//通用reset
   
    //模式选择
    Mod_control mod_c(
        .clk(clk),
        .mod_con(mod_con),
        .enable_mod(enable_mod)
        );
   
   //按键消抖模块
   Button_detect bt1(.clk(clk),.rst_n(rstmod),.key(key_1), .key_value(sig_1) );
   Detect dt1(.sig(sig_1),.clk(clk),.rst(rstmod),.flag(val_1));
   Button_detect bt2(.clk(clk),.rst_n(rstmod),.key(key_2), .key_value(sig_2) );
   Detect dt2(.sig(sig_2),.clk(clk),.rst(rstmod),.flag(val_2));
   Button_detect bt3(.clk(clk),.rst_n(rstmod),.key(key_3), .key_value(sig_3) );
   Detect dt3(.sig(sig_3),.clk(clk),.rst(rstmod),.flag(val_3));
   Button_detect bt4(.clk(clk),.rst_n(rstmod),.key(key_4), .key_value(sig_4) );
   Detect dt4(.sig(sig_4),.clk(clk),.rst(rstmod),.flag(val_4));
   
   //分模式运行 基于clk     
    //Mod1状态机
    Mod1_ztj m1_ztj(
        .clk(clk),.rst(mod_con1),
        .key_start_stop(val_1),.key_load(val_2),.finish_delay(finish_delay),
        .cnt_en(cnt_en), .load(load)//, .pausedelay(pausedelay)
        );
    //秒频
    Sec_pulse driver_sec(
        .clk(clk),
        .rst_n(mod_con1),
        .sec_pulse(sec_pulse)
        );
    //分频
    Negecount_60 ncnt1_60(
        .clk(clk), .pulse_in(sec_pulse), .rst_n(mod_con1),
        .cnt_en(cnt_en),.load(load),//,.pausedelay(pausedelay),
        .borrow(borrow1),//传set脉冲
        .x(x1)//BCD码计数
        );
        
    //预设
    Preset_num pre_s(
    .clk(clk),.rst(mod_con1),
    .cnt_en(cnt_en),.load(load),
    .upset(val_3), .downset(val_4),
    .setnum(preset)
    );
    //时频
    Negecount1_preset ncnt1_set(
        .clk(clk),.pulse_in(borrow1),.rst_n(mod_con1),
        .preset(preset),
       // .upset(val_3), .downset(val_4),
        .cnt_en(cnt_en),.load(load),//,.pausedelay(pausedelay),
        .x(x2)//BCD码计数
        ); 
    //pause分频
    Negecount2_60 ncnt2_60(
        .clk(clk), .pulse_in(sec_pulse), .rst_n(mod_con1),
        .cnt_en(cnt_en),.load(load),//,.pausedelay(pausedelay),
        .borrow(borrow2),//传5脉冲
        .x(x3)//BCD码计数
        );
    //pause时频
    Negecount_5 ncnt_5(
        .clk(clk), .pulse_in(borrow2), .rst_n(mod_con1),
        .cnt_en(cnt_en),.load(load),//,.pausedelay(pausedelay),
        .x(x4),//BCD码计数
        .finish_delay(finish_delay)
        );
       
    //Mod2状态机
    Mod2_ztj m2_ztj(
        .clk(clk),.rst(mod_con2),
        .key_start_stop(val_1),.key_load(val_2),.key_read(val_4),
        .cnt_en(cnt_en2), .load(load2)//, .pausedelay(pausedelay)
        ); 
      
     //秒频
    Sec_pulse driver_sec_po(
        .clk(clk),
        .rst_n(mod_con2),
        .sec_pulse(sec_pulse2)
        );
    //分频
    Posecount_60 pcnt1_60(
        .clk(clk), .pulse_in(sec_pulse2), .rst_n(mod_con2),
        .cnt_en(cnt_en2),.load(load2),//,.pausedelay(pausedelay),
        .borrow(borrow3),//传set脉冲
        .x(x5)//BCD码计数
        );
    //预设
    Preset_num pre_s2(
    .clk(clk),.rst(mod_con2),
    .cnt_en(cnt_en),.load(load),
    .upset(val_3), .downset(val_4),
    .setnum(preset2)
    );
    //时频
    Posecount_30 pcnt_30(
        .clk(clk), .pulse_in(borrow3), .rst_n(mod_con2),
        .cnt_en(cnt_en2),.load(load2),//,.pausedelay(pausedelay),
        .perse(preset2),
        .x(x6)//BCD码计数
        );
        
    //读数
    Read r_p(
    .clk(clk),.rst_n(mod_con2),
    .key_cut(val_3),
    .cnt_en(cnt_en2),.load(load2),//,.pausedelay(pausedelay),
    .x1(x5),
    .x2(x6),
    .x7(x7),
    .x8(x8)
    );
        
     //display
    reg[7:0]x_1 = 0;
    reg[7:0]x_2 = 0;
    reg[7:0]x_3 = 0;
    reg[7:0]x_4 = 0;
   
    always @(posedge clk or posedge enable_mod or negedge enable_mod) begin
    if( enable_mod == Mod1) 
    begin x_1=x1;x_2=x2;x_3=x3;x_4=x4;end
    else if( enable_mod == Mod2)
    begin x_1=x5;x_2=x6;x_3=x7;x_4=x8;end
    end
    
    Display_x7seg display1(
    .clk(clk),
    .rst_n(rstmod),//模式使能
    .x1(x_1),.x2(x_2),
    .a_to_g(a_to_g1),//段信号
    .an(an1) //位选信号 
    );
    Display_x7seg display2(
    .clk(clk),
    .rst_n(rstmod),//模式使能
    .x1(x_3),.x2(x_4),
    .a_to_g(a_to_g2),//段信号
    .an(an2) //位选信号 
    );
    
endmodule
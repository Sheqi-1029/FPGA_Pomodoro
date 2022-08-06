module Main_tomato(
    input clk,
    input mod_con,//״̬����
    input mod_con1,//״̬1 reset����
    input mod_con2,//״̬2 reset����
    //mod1 - mod2
    input key_1,//Reset
    input key_2,//Pause - stop
    input key_3,//Ԥ�ü� - cut 
    input key_4,//Ԥ�ü� - �Ϸ�
    
    output wire [7:0] led,// LED���ź�
    output wire [6:0] a_to_g1,//���ź�
    output wire [3:0] an1, //λѡ�ź� 
    output wire [6:0] a_to_g2,//���ź�
    output wire [3:0] an2 //λѡ�ź�
    );
    //significant fastor begin
    wire rstmod;
    wire[31:0] x;//����ʾ�������
    parameter Mod1 = 0,Mod2 = 1;//ģʽѡ��
    wire x_reg;//����ʾ������ݼĴ�
    wire enable_mod;//ģʽʹ��
    wire sig_1,sig_2,sig_3,sig_4;
    wire val_1,val_2,val_3,val_4;
    //mod 1
    wire finish_delay;
    wire sec_pulse, borrow1,borrow2;
    wire[7:0] preset;
    wire[7:0] x1;//60����
    wire[7:0] x2;//set����
    wire[7:0] x3;//60����
    wire[7:0] x4;//5����
    wire cnt_en,load;//,pausedelay;//״̬��
    //mod 2
    wire sec_pulse2,borrow3;
    wire [2:0] cut_num;//��������
    wire [63:0] cut;//��¼��
    wire[7:0] x5;//60����
    wire[7:0] x6;//min����
    wire[7:0] x7;//00����
    wire[7:0] x8;//��ż��� 
    wire cnt_en2,load2;//,pausedelay;//״̬��
    wire[7:0] preset2;
    //significant fastor end
   
   assign rstmod = (enable_mod == Mod1)? mod_con1 : mod_con2;//ͨ��reset
   
    //ģʽѡ��
    Mod_control mod_c(
        .clk(clk),
        .mod_con(mod_con),
        .enable_mod(enable_mod)
        );
   
   //��������ģ��
   Button_detect bt1(.clk(clk),.rst_n(rstmod),.key(key_1), .key_value(sig_1) );
   Detect dt1(.sig(sig_1),.clk(clk),.rst(rstmod),.flag(val_1));
   Button_detect bt2(.clk(clk),.rst_n(rstmod),.key(key_2), .key_value(sig_2) );
   Detect dt2(.sig(sig_2),.clk(clk),.rst(rstmod),.flag(val_2));
   Button_detect bt3(.clk(clk),.rst_n(rstmod),.key(key_3), .key_value(sig_3) );
   Detect dt3(.sig(sig_3),.clk(clk),.rst(rstmod),.flag(val_3));
   Button_detect bt4(.clk(clk),.rst_n(rstmod),.key(key_4), .key_value(sig_4) );
   Detect dt4(.sig(sig_4),.clk(clk),.rst(rstmod),.flag(val_4));
   
   //��ģʽ���� ����clk     
    //Mod1״̬��
    Mod1_ztj m1_ztj(
        .clk(clk),.rst(mod_con1),
        .key_start_stop(val_1),.key_load(val_2),.finish_delay(finish_delay),
        .cnt_en(cnt_en), .load(load)//, .pausedelay(pausedelay)
        );
    //��Ƶ
    Sec_pulse driver_sec(
        .clk(clk),
        .rst_n(mod_con1),
        .sec_pulse(sec_pulse)
        );
    //��Ƶ
    Negecount_60 ncnt1_60(
        .clk(clk), .pulse_in(sec_pulse), .rst_n(mod_con1),
        .cnt_en(cnt_en),.load(load),//,.pausedelay(pausedelay),
        .borrow(borrow1),//��set����
        .x(x1)//BCD�����
        );
        
    //Ԥ��
    Preset_num pre_s(
    .clk(clk),.rst(mod_con1),
    .cnt_en(cnt_en),.load(load),
    .upset(val_3), .downset(val_4),
    .setnum(preset)
    );
    //ʱƵ
    Negecount1_preset ncnt1_set(
        .clk(clk),.pulse_in(borrow1),.rst_n(mod_con1),
        .preset(preset),
       // .upset(val_3), .downset(val_4),
        .cnt_en(cnt_en),.load(load),//,.pausedelay(pausedelay),
        .x(x2)//BCD�����
        ); 
    //pause��Ƶ
    Negecount2_60 ncnt2_60(
        .clk(clk), .pulse_in(sec_pulse), .rst_n(mod_con1),
        .cnt_en(cnt_en),.load(load),//,.pausedelay(pausedelay),
        .borrow(borrow2),//��5����
        .x(x3)//BCD�����
        );
    //pauseʱƵ
    Negecount_5 ncnt_5(
        .clk(clk), .pulse_in(borrow2), .rst_n(mod_con1),
        .cnt_en(cnt_en),.load(load),//,.pausedelay(pausedelay),
        .x(x4),//BCD�����
        .finish_delay(finish_delay)
        );
       
    //Mod2״̬��
    Mod2_ztj m2_ztj(
        .clk(clk),.rst(mod_con2),
        .key_start_stop(val_1),.key_load(val_2),.key_read(val_4),
        .cnt_en(cnt_en2), .load(load2)//, .pausedelay(pausedelay)
        ); 
      
     //��Ƶ
    Sec_pulse driver_sec_po(
        .clk(clk),
        .rst_n(mod_con2),
        .sec_pulse(sec_pulse2)
        );
    //��Ƶ
    Posecount_60 pcnt1_60(
        .clk(clk), .pulse_in(sec_pulse2), .rst_n(mod_con2),
        .cnt_en(cnt_en2),.load(load2),//,.pausedelay(pausedelay),
        .borrow(borrow3),//��set����
        .x(x5)//BCD�����
        );
    //Ԥ��
    Preset_num pre_s2(
    .clk(clk),.rst(mod_con2),
    .cnt_en(cnt_en),.load(load),
    .upset(val_3), .downset(val_4),
    .setnum(preset2)
    );
    //ʱƵ
    Posecount_30 pcnt_30(
        .clk(clk), .pulse_in(borrow3), .rst_n(mod_con2),
        .cnt_en(cnt_en2),.load(load2),//,.pausedelay(pausedelay),
        .perse(preset2),
        .x(x6)//BCD�����
        );
        
    //����
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
    .rst_n(rstmod),//ģʽʹ��
    .x1(x_1),.x2(x_2),
    .a_to_g(a_to_g1),//���ź�
    .an(an1) //λѡ�ź� 
    );
    Display_x7seg display2(
    .clk(clk),
    .rst_n(rstmod),//ģʽʹ��
    .x1(x_3),.x2(x_4),
    .a_to_g(a_to_g2),//���ź�
    .an(an2) //λѡ�ź� 
    );
    
endmodule
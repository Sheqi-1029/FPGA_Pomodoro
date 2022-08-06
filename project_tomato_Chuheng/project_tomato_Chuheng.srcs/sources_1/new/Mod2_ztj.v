module Mod2_ztj(
 input clk,
    input rst,
    input key_load,
    input key_start_stop,
    input key_read,
    output reg cnt_en,
    output reg load
    //output reg pausedelay
    );
reg [1:0]cstate;  //ÏÖÌ¬
reg [1:0]nstate;  //´ÎÌ¬
parameter 
    WORK_INIT = 2'b00,
    PAUSE = 2'b01,
    COUNT = 2'b11,
    READ = 2'b10;
//cstate
always @(posedge clk or posedge rst)
if(rst)
    cstate <= WORK_INIT;
else 
    cstate <= nstate;
//nstate
always @*
case(cstate)
    WORK_INIT:  if(key_start_stop == 1) nstate = COUNT;
                else nstate = cstate;
    COUNT:  if(key_start_stop == 1) nstate = PAUSE;
            else nstate = cstate;
    PAUSE:  if(key_load == 1) nstate = WORK_INIT;
            else if (key_read  == 1) nstate = READ;
            else nstate = cstate;
    READ: if(key_load == 1) nstate = WORK_INIT;
            else nstate = cstate;
    default nstate = WORK_INIT;
endcase        
//output
always@ (posedge clk or posedge rst)
if(rst)  begin cnt_en <= 0;load <= 1;  end //pausedelay <= 1;
else
    case (cstate)
        WORK_INIT:     
        begin
            cnt_en <= 0; load <= 1; //pausedelay <= 1;
         end 
        COUNT:
        begin
            cnt_en <= 1; load <= 0; //pausedelay <= 1;
         end    
        PAUSE:
        begin
            cnt_en <= 0;load <= 0; //pausedelay <= 0;
         end 
         READ:
         begin
            cnt_en <= 1;load <= 1; //pausedelay <= 0;
         end 
         default: 
         begin
            cnt_en <= 0;load <= 1; //pausedelay <= 1;
         end  
    endcase
endmodule

 module Mod_control(
        input clk,
        input mod_con,
        output wire enable_mod
        );
   parameter Mod1 = 0,Mod2 = 1;//Ä£Ê½Ñ¡Ôñ
   reg enmod;
   always @(posedge clk or posedge mod_con)
   begin
       enmod = (mod_con == 1)? Mod2: Mod1;
   end
   assign enable_mod = enmod;
 endmodule
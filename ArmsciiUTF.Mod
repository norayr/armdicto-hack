MODULE ArmsciiUTF;

TYPE string* = POINTER TO ARRAY OF CHAR;
     uchar* = ARRAY 4 OF CHAR;

VAR map : ARRAY 255 OF uchar;

PROCEDURE StripNull(VAR str : uchar): string;
VAR pchar : string;
   i, j : INTEGER;
BEGIN

   i := 0;

   REPEAT
       INC(i); 
   UNTIL str[i] = 0X;
   
   NEW(pchar, i+1);

   j := 0;
   REPEAT
      pchar^[j] := str[j];
      INC(j);
   UNTIL j = i;
 
   RETURN pchar

END StripNull;


PROCEDURE A2U*(ch : CHAR): string;
VAR 
    str0   : uchar;
    pch : string;
BEGIN

   str0 := map[ORD(ch)];
   RETURN StripNull(str0); 
   (*NEW(pch, 4);
   COPY(str0, pch^);
   RETURN pch;*)
END A2U;

BEGIN

map[162] := "և";
map[163] := ":";
map[164] := ")";
map[165] := "(";
map[166] := "»";
map[167] := "«";
map[168] := "—";
map[169] := "․";
map[170] := "՝";
map[171] := ",";
map[172] := "-";
map[173] := "֊";
map[174] := "…";
map[175] := "՜";
map[176] := "՛";
map[177] := "՞";
map[178] := "Ա";
map[179] := "ա";
map[180] := "Բ";
map[181] := "բ";
map[182] := "Գ";
map[183] := "գ";
map[184] := "Դ";
map[185] := "դ";
map[186] := "Ե";
map[187] := "ե";
map[188] := "Զ";
map[189] := "զ";
map[190] := "Է";
map[191] := "է";
map[192] := "Ը";
map[193] := "ը";
map[194] := "Թ";
map[195] := "թ";
map[196] := "Ժ";
map[197] := "ժ";
map[198] := "Ի";
map[199] := "ի";
map[200] := "Լ";
map[201] := "լ";
map[202] := "Խ";
map[203] := "խ";
map[204] := "Ծ";
map[205] := "ծ";
map[206] := "Կ";
map[207] := "կ";
map[208] := "Հ";
map[209] := "հ";
map[210] := "Ձ";
map[211] := "ձ";
map[212] := "Ղ";
map[213] := "ղ";
map[214] := "Ճ";
map[215] := "ճ";
map[216] := "Մ";
map[217] := "մ";
map[218] := "Յ";
map[219] := "յ";
map[220] := "Ն";
map[221] := "ն";
map[222] := "Շ";
map[223] := "շ";
map[224] := "Ո";
map[225] := "ո";
map[226] := "Չ";
map[227] := "չ";
map[228] := "Պ";
map[229] := "պ";
map[230] := "Ջ";
map[231] := "ջ";
map[232] := "Ռ";
map[233] := "ռ";
map[234] := "Ս";
map[235] := "ս";
map[236] := "Վ";
map[237] := "վ";
map[238] := "Տ";
map[239] := "տ";
map[240] := "Ր";
map[241] := "ր";
map[242] := "Ց";
map[243] := "ց";
map[244] := "Ւ";
map[245] := "ւ";
map[246] := "Փ";
map[247] := "փ";
map[248] := "Ք";
map[249] := "ք";
map[250] := "Օ";
map[251] := "օ";
map[252] := "Ֆ";
map[253] := "ֆ";
map[254] := "՚";





END ArmsciiUTF.

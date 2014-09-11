MODULE armdictohack;

IMPORT Files, Out := Console, SYSTEM,
       ArmsciiUTF;

CONST maindat = "maintest.dat";
      outtxt  = "out.txt";

PROCEDURE WriteChar(VAR r : Files.Rider; ch : CHAR);
BEGIN
   Files.WriteByte(r, SHORT(ORD(ch))); (* write ascii character *)
   Out.Char(ch);
END WriteChar;

PROCEDURE WriteString(VAR r : Files.Rider; str : ArmsciiUTF.string);
BEGIN
   Files.WriteBytes(r, str^, LEN(str^)-1);
   Out.String(str^);
END WriteString;
(*
PROCEDURE Fix(VAR r : Files.Rider; VAR f : Files.File);
BEGIN

   Files.Set(r, f, 2191531); (* 002170AB is 2191531 *)
   Files.WriteByte(r, 111); (* replace errorneus armscii-8 o with latin o *)

   Files.Set(r, f, 2999763); (* 002dc5d3 is 2999763 *)
   Files.WriteByte(r, 111); (* same here, armscii-8 "o" letter in English word should be latin *)

   Files.Set(r, f, 1815116);
   Files.WriteByte(r, 0);

   Files.Set(r, f, 2245510); (* fix "hello" translation at address 00224386H *)
   Files.WriteByte(r, 175) (* af is ՜ in armscii-8 *)
END Fix;
*)
PROCEDURE Go;
   VAR f, fo : Files.File;
       r, ro : Files.Rider;
       ch : CHAR;
       ord, i: INTEGER;
       str : ArmsciiUTF.string;
       last : BOOLEAN;
BEGIN
   f := Files.Old(maindat);
   IF f # NIL THEN
  (*    Fix(r, f);*)
      Files.Set(r, f, 0);
      
      
      fo := Files.New(outtxt);
      IF fo # NIL THEN
         Files.Set(ro, fo, 0);
	 last := FALSE;
         WHILE ~ r.eof DO
	    (* expecting zeros *)
	    REPEAT
	       Files.Read(r, ch);
	       ord := ORD(ch);
	    UNTIL (ord # 0) OR r.eof;
	    
	    IF ~r.eof THEN 
	       WriteChar(ro, ch);
	       (* expecting English word *)
               REPEAT
                  Files.Read(r, ch);
                  ord := ORD(ch);
                  IF ord # 0 THEN
	             WriteChar(ro, ch);
	          (*ELSE
	             Files.Read(r, ch);
                     ord := ORD(ch);*)
	          END;
               UNTIL ord = 0;
	       WriteChar(ro, 9X); (* write tab *)   
	       (* expecting zeros *)
	       REPEAT
	          Files.Read(r, ch);
	          ord := ORD(ch);
	       UNTIL ord >= 162;

	      (* expecting Armenian *)
	       REPEAT

	         IF ord < 162 THEN
                    WriteChar(ro, ch);
	         ELSE
                    str := ArmsciiUTF.A2U(ch); 
		    WriteString(ro, str);
	         END;
              
	         Files.Read(r, ch); 
	         ord := ORD(ch);
		 IF ord = 0 THEN (* skip everything before three zeros *)
		    i := 0;
		    REPEAT
                       Files.Read(r, ch);
		       ord := ORD(ch);
		       IF ord = 0 THEN INC(i) ELSE IF i >0 THEN DEC(i) END END;
		    UNTIL i = 10;
		 END
               UNTIL ord = 0;
	       WriteChar(ro, 0AX);
            END;
      END;

	    WriteChar(ro, 0AX);
	    WriteChar(ro, 0AX);
            Files.Register(fo);
      
      ELSE
         Out.String(outtxt); Out.String("cannot be created, check permissions"); Out.Ln
      END
   ELSE
         Out.String(maindat); Out.String (" not found in current directory"); Out.Ln
   END

END Go;



BEGIN

Go;


END armdictohack.

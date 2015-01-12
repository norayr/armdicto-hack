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

PROCEDURE Fix(VAR r : Files.Rider; VAR f : Files.File);
VAR WrongYev, RightYev, WrongExclam, RightExclam : CHAR;
i : LONGINT;
ch, lch : CHAR;
BEGIN

   WrongYev := 0A8X;
   RightYev := 0A2X;
   WrongExclam := 07EX; (* ~ *)
   RightExclam := 0AFX;

   i := 0; lch := ' ';
   Files.Set(r, f, i);

   WHILE ~ r.eof DO
      Files.Set(r, f, i);
      Files.Read(r, ch);
      IF ch = WrongYev THEN
	 Files.Set(r, f, i);
         Files.WriteByte(r, RightYev);
	 (*Files.Set(r, f, i+1);*)
      END;
      IF (ch = WrongExclam) & (lch > 0A2X) THEN
         Files.Set(r, f, i);
         Files.WriteByte(r, RightExclam); 
         (*Files.Set(r, f, i+1);  *)
      END;
      lch := ch;
      INC(i);
   END;

   Files.Set(r, f, 2191531); (* 002170AB is 2191531 *)
   Files.WriteByte(r, 111); (* replace errorneus armscii-8 o with latin o *)

   Files.Set(r, f, 2999763); (* 002dc5d3 is 2999763 *)
   Files.WriteByte(r, 111); (* same here, armscii-8 "o" letter in English word should be latin *)

   Files.Set(r, f, 1815116);
   Files.WriteByte(r, 0);

   (* wrong translation of "lentil", it is "սուպ" instead of "ոսպ" *)

   Files.Set(r, f, 2782295);
   Files.WriteByte(r, (*225*)0E1X); (* ո *)

   Files.Set(r, f, 2782296);
   Files.WriteByte(r, (*235*)0EBX); (* ս *)

   Files.Set(r, f, 2782297);
   Files.WriteByte(r, (*229*)0E5X);  (* պ *)
  
   Files.Set(r, f, 2782298);
   Files.WriteByte(r, 0);  (* nothing *)
   

(*
   Files.Set(r, f, 2245510); (* fix "hello" translation at address 00224386H *)
   Files.WriteByte(r, 0A2X); (* af is ՜ in armscii-8 *)

   Files.Set(r, f, 5465087);
   Files.WriteByte(r, 0A2X);
   *)
END Fix;

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
      Fix(r, f);
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

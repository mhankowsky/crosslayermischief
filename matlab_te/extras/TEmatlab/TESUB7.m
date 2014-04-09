function TESUB7VAL = TESUB7(I);
      global G;
      G = rem(G * 9228907,4294967296);
	  if I >= 0;
      TESUB7VAL = G / 4294967296;
	  else
	  TESUB7VAL = 2 * G / 4294967296 - 1;
      return
      end

function      H = TESUB1(Z,T,H,ITY,AH,BH,CH,AG,BG,CG,AV,XMW);
   %	   TESUB1VAL = TESUB1(Z,T,H,ITY)	
	% Substitution of TESUB1 for call statement MWB
	%
	if ITY == 0
    	H = 0;
		for I = 1:8
      		HI = T * (AH(I,1) + BH(I,1) * T / 2 + CH(I,1) * T^2 / 3);
      		HI = 1.8 * HI;
      		H = H + Z(I,1) * XMW(I,1) * HI;
		end
	else
      	H = 0;
		for I = 1:8 
      		HI = T * (AG(I,1) + BG(I,1) * T / 2 + CG(I,1) * T^2 / 3);
      		HI = 1.8 * HI;
      		HI = HI + AV(I,1);
      		H = H + Z(I,1) * XMW(I,1) * HI;
		end
	end
	if ITY == 2
      	R1 = 3.57696 / 1000000;
     	H = H - R1 * (T + 273.15);
  	end
	%
	% End of TESUB1 sub
	%

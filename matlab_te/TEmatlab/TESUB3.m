function DH = TESUB3(Z,T,DH,ITY,AH,BH,CH,AG,BG,CG,XMW);
	%		TESUB3VAL = TESUB3(Z,T,DH,ITY)
	% Substitution of TESUB3 for call statement MWB
	%
	if ITY == 0
      	DH = 0.0;
    	for I = 1:8
      		DHI = AH(I,1) + BH(I,1) * T + CH(I,1) * T^2;
      		DHI = 1.8 * DHI;
      		DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	else
      	DH=0.0;
    	for I = 1:8
      		DHI = AG(I,1) + BG(I,1) * T + CG(I,1) * T^2;
      		DHI = 1.8 * DHI;
      		DH = DH + Z(I,1) * XMW(I,1) * DHI;
		end
	end
	if ITY == 2
      	R3 = 3.57696/1000000;
     	DH = DH - R3;
 	end
	%
	% End of TESUB3 substitution.
	%

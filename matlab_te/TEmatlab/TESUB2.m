%     TESUB2(XLR,TCR,ESR,0);
function T = TESUB2(Z,T,H,ITY,AH,BH,CH,AG,BG,CG,AV,XMW);
% Substitution of TESUB2 for call statement. MWB
% TESUB2 appears to update T and only T.
	  TIN=T;
for J = 1:100
	HTEST = TESUB1(Z,T,HTEST,ITY,AH,BH,CH,AG,BG,CG,AV,XMW);
   ERR = HTEST - H;
	
	% 		TESUB3VAL = TESUB3(Z,T,DH,ITY)
   %		TESUB3VAL = TESUB3(Z,T,DH,ITY)
   DH = TESUB3(Z,T,DH,ITY,AH,BH,CH,AG,BG,CG,XMW);
	    DT = -ERR / DH;
    T = T + DT;
  	if abs(DT) < 1*10^(-12)
    	break
  	end
  	if J == 100
  		T = TIN;
  	end
end
% End of TESUB2.

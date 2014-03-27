%	  TESUB4(XLR,TCR,DLR);
function R = TESUB4(X,T,R,AD,BD,CD,XMW);
% Substitution of TESUB4 for call statement. MWB
V = 0.0;
for I = 1:8
	V = V + X(I,1) * XMW(I,1) / (AD(I,1) + (BD(I,1) + CD(I,1) * T) * T);
end
R = 1.0 / V;
% End of TESUB4.

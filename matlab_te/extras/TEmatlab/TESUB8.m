      function TESUB8VAL = TESUB8(I,T)
%       DOUBLE PRECISION  H,T
%       DOUBLE PRECISION
%      .ADIST,
%      .BDIST,
%      .CDIST,
%      .DDIST,
%      .TLAST,
%      .TNEXT,
%      .HSPAN,
%      .HZERO,
%      .SSPAN,
%      .SZERO,
%      .SPSPAN
      global ADIST BDIST CDIST DDIST TLAST TNEXT...
      HSPAN HZERO SSPAN SZERO SPSPAN IDVWLK;
	  H = T - TLAST(I,1);
      TESUB8VAL = ADIST(I,1) + H * (BDIST(I,1) + H * (CDIST(I,1) + H * DDIST(I,1)));
      return

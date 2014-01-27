function out = unfire(f)

%if f > 1 - consts.EPS
%    f = 1 - consts.EPS;
%elseif f < -(1 - consts.EPS)
%    f = -(1 - consts.EPS);
%end

out = atanh(f) / consts.BETA;
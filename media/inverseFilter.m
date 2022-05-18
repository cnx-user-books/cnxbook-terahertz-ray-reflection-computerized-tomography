function p = inverseFilter(s,r,gamma,d);
%
% p = inverseFilter(y,h,gamma,d);
%
% Generalized inverse filtering using threshold gamma:
%
%  inv_g(R) = gamma*abs(fft(r))/fft(r), if abs(fft(r)) <= 1/gamma
%  inv_g(R) = inv(R),			otherwise
%
% Reference: J.S.Lim,"Two dimensional signal and image processing", 
%            Prentice Hall, 1990- pg.552 Eq.(9.50)
%
%d is a vector of the form d(m)= exp(-i*w*m) that takes care of the delay
%that the linear phase inverse filter causes in th etime domain

N= length(s);
S = fft(s);
R = fft(r);

% handle singular case (zero case)
R1 = R.*(abs(R)>0)+1/gamma.*(abs(R)==0);
iR = 1./R1;
%  
% invert Hf using threshold gamma
G = iR.*(abs(R)*gamma>1)+gamma*abs(R1).*iR.*(abs(R1)*gamma<=1);

p = real(ifft(S.*G.*d));

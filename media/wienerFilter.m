function p = wienerFilter(s,r,thres,gamma,d);
%
% p = wienerFilter(y,h,thres,gamma,d);
%
% Implementation of Inverse and Denoise filters in cascade
%
% Reference: J.S.Lim,"Two dimensional signal and image processing", 
%            Prentice Hall, 1990- pg.560 Eq.(9.73)
%
%d is a vector of the form d(m)= exp(-i*w*m) that takes care of the delay
%that the linear phase inverse filter causes in th etime domain
%

N= length(s);
S = fft(s);
R = fft(r);
Syy = abs(S).^2/N^2;

%% Estimation of noise variance from measurements (Gaussian white noise is assumed)
%Takes into advantage the first part of each measurement that contains only
%noise and not actual reflection data of the object.
%Above the threshold (thres) we assume that we start receiving actual 
%reflection data, and thus we stop the estimation of the variance of the noise
sigma= var(s(1:min(find(s>= thres))));

% Implementation of the inverse filtering part
Rf = R.*(abs(R)>0)+1/gamma*(abs(R)==0);
iRf = 1./Rf;
iRf = iRf.*(abs(R)*gamma>1)+gamma*abs(Rf).*iRf.*(abs(Rf)*gamma<=1);

W = iRf.*Syy./(Syy+ sigma); %Inverse and denoise filters in cascade 

% Filtering in frequency domain and back to time domain
p = real(ifft(S.*W.*d));

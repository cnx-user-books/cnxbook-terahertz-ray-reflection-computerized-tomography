%% Deconvolution/denoising using Wiener Filter
%Utilizes inverseFilter and wienerFilter m-files

%% EXTREMELY IMPORTANT... TAKES CARE OF THE DELAY...IN FREQ. DOMAIN!!!
d= zeros(23606,1);
w= 2*pi/23606*11610; %23606/2=11803
for m= 1:23606
    d(m)= exp(-i*w*m);
end

%sigma= 0.000001;
thres= 0.003;
gamma= 10^(-7);
%alpha= 1;
pw= zeros(23606,360);
for k= 1:360
    pw(:,k)= wienerFilter(C_m(:,k),reference_m,thres,gamma,d);
    %sigma(k)= var(C_m(:,k)(1:min(find(C_m(:,k)>= thres))));
end

gamma= 10^(-7);
p= zeros(23606,360);
for k= 1:360
    p(:,k)= inverseFilter(C_m(:,k),reference_m,gamma,d);
end

%% Plots
figure;
deg= 70; %Plot of measurement at angle deg
subplot(311)
plot(timedelay, C_m(:,70))
title(['Observed measurement at angle ',num2str(deg),' degrees']) 
xlabel('Time delay (ps)')
ylabel('Electric field (arb. units)')
subplot(312)
plot(timedelay, p(:,70))
title(['projection at angle ',num2str(deg),' degrees (Inverse filtering)'])
xlabel('Time delay (ps)')
ylabel('Electric field (arb. units)')
subplot(313)
plot(timedelay, pw(:,70))
title(['projection at angle ',num2str(deg),' degrees (Wiener filtering)'])
xlabel('Time delay (ps)')
ylabel('Electric field (arb. units)')

%%%SINOGRAMS%%%
figure;
subplot(131)
x=[1:360];
imagesc(x,timedelay,C_m)
colormap(gray)
axis([1 360 0 400])
xlabel('Viewing angle (degrees)')
ylabel('Time delay (ps)')
title('Measured waveforms') 

% figure;
subplot(132)
imagesc(x,timedelay,p)
colormap(gray)
axis([1 360 0 400])
xlabel('Viewing angle (degrees)')
ylabel('Time delay (ps)')
title('Projections (Inverse filter)') 

%figure;
subplot(133)
imagesc(x,timedelay,pw)
colormap(gray)
axis([1 360 0 400])
xlabel('Viewing angle (degrees)')
ylabel('Time delay (ps)')
title('Projections (Wiener filter)')

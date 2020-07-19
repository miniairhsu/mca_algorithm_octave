#signal generation
clear all
%sample rate
ts = 1e-4;
L = 4096
t = (0:L-1) * ts;
x = (1+cos(2*pi*50*t)).*cos(2*pi*1000*t);
#write gaissian pulse datafileID = fopen('exp.txt','w');
fileXi = fopen('modulation.txt','w');
fprintf(fileXi,'%6.2fs\n',x);
fclose(fileXi);

subplot(2,2,1)
plot(t,x)

%hilbert transoform
y = hilbert(x);
env = abs(y);
plot_param = {'Color', [0.6 0.1 0.2],'Linewidth',2};
subplot(2,2,2) 
plot(t,[-1;1]*env,plot_param{:})
hold off
title('Hilbert Envelope')

#envolope extraction analytic 
FL = L; #frequency domain data length
Xf = fft(x, FL);
fz = zeros(1, FL/2);
xf1 = [Xf(1:FL/2), fz] 
%envolope
zf1 = ifft(xf1);
f = (0:FL-1) / (FL * ts);
subplot(2,2,3);
plot(t, abs(zf1));
grid on
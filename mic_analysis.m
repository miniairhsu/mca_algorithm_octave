clear all
#audio signal recroding and ploting
T = 1;
Fs = 10000;
s = record(T, Fs);
s_size = size(s);
subplot(2,2,1)
plot(s) 
grid on

#FFT process 
FL = 512; #frequency domain data length
Sf = abs(fft(s, FL))';
#f = (0:FL-1)*F/FL;
f = (0:FL-1);
subplot(2,2,2);
plot(f, abs(Sf));
grid on

#envolope extraction analytic 
fz = zeros(1, FL/2);
sf1 = [Sf(1:FL/2), fz];
%envolope
zf1 = ifft(sf1);
subplot(2,2,3);
plot(f, zf1);
grid on
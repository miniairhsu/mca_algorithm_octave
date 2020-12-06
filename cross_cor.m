#signal generation
clear all
function p = pulsePower(x)
    p = sum(x) / length(x);
end

function [p_frame, frame] = pulsePower_frame(x, n)
  t = idivide(length(x), n);
  frame = 0:1:t-1 
  for i = 0:1:(t-1)
    p_frame(i+1) = pulsePower(x((i*n + 1) : i*n + n));
  end 
end


L = 4096; #data length
F = 200; #sample frequency Hz
T = 1/F; #sample period
t = (0:L-1)*T;
Xi = gauspuls(t,20,0.3); 
Xi = circshift(Xi', 10);
Yi = gauspuls(t, 20,0.3); 
Yi = circshift(Yi', 10);
Xi = Xi';
Yi = Yi';
[Pi1, frame1]  = pulsePower_frame(Xi, 16)
[Pi2, frame2]  = pulsePower_frame(Yi, 16)
figure(1)
subplot(2,2,1)
plot(frame1, Pi1, frame2, Pi2);
grid on
#write gaissian pulse datafileID = fopen('exp.txt','w');
fileXi = fopen('Xi.txt','w');
fprintf(fileXi,'%6.2fs\n',Xi);
fclose(fileXi);

fileYi = fopen('Yi.txt','w');
fprintf(fileYi,'%6.2fs\n',Yi);
fclose(fileYi);
figure(2)
subplot(2,2,1)
plot(t, Xi, t, Yi);
grid on

#FFT process 
FL = 512; #frequency domain data length
Xf = fft(Xi, FL);
Yf = fft(Yi, FL);
#f = (0:FL-1)*F/FL;
f = (0:FL-1);

fileXif = fopen('Xi_f.csv','w');
fprintf(fileXif,'%6.2fs\n',Xf);
fclose(fileXif);

fileYif = fopen('Yi_f.csv','w');
fprintf(fileYif,'%6.2fs\n',Yf);
fclose(fileYif);

subplot(2,2,2);
plot(f, abs(Xf), f, abs(Yf));
grid on

#cross correlation process
[c,lags] = xcorr(Xi, Yi);
subplot(2,2,3)
plot(lags + 512, c);
grid on

#multiply FFT vectors
Yf = flip(Yf);
Zf = Xf.*Yf;
Zf = ifft(Xf.*Yf);
Zf = fftshift(Zf);

fileZf = fopen('Zf.csv','w');
fprintf(fileZf,'%6.2fs\n',Zf);
fclose(fileZf);
tz = (0:FL-1);
subplot(2,2,4)
plot(tz, (Zf));
grid on









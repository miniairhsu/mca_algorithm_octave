#signal generation
clear all
L = 512; #data length
F = 200; #sample frequency Hz
T = 1/F; #sample period
t = (0:L-1)*T;
Xi = gauspuls(t,20,0.2); 
Xi = circshift(Xi', 5);
Yi = gauspuls(t, 20,0.3); 
Yi = circshift(Yi', 5);
Xi = Xi';
Yi = Yi';

#write gaissian pulse datafileID = fopen('exp.txt','w');
fileXi = fopen('Xi.txt','w');
fprintf(fileXi,'%6.2fs\n',Xi);
fclose(fileXi);

fileYi = fopen('Yi.txt','w');
fprintf(fileYi,'%6.2fs\n',Yi);
fclose(fileYi);
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
w = conv(Xi, Yi);
subplot(2,2,3)
plot(w);
grid on
xlim([0 600])

#multiply FFT vectors;
Zf = ifft(Xf.*Yf);
#Zf = fftshift(Zf);

fileZf = fopen('Zf.csv','w');
fprintf(fileZf,'%6.2fs\n',Zf);
fclose(fileZf);
tz = (0:FL-1);
subplot(2,2,4)
plot(tz, (Zf));
grid on
xlim([0 600])
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


L = 1024; #data length
F = 10e6; #sample frequency Hz
T = 1/F; #sample period
frame_size = 32;
pkt_size = 128; #must be power of 2
t = (0:(L*pkt_size)-1)*T; #10ms

%gnerate gassian pulse for simulation
Xi = gauspuls(t, 5e3,0.2); 
Xi = circshift(Xi', 2000);
Yi = gauspuls(t, 7e3,0.4); 
Yi = circshift(Yi', 12000);
fileXi = fopen('Xi.txt','w');
fprintf(fileXi,'%6.2fs\n',Xi);
fclose(fileXi);
fileYi = fopen('Yi.txt','w');
fprintf(fileYi,'%6.2fs\n',Yi);
fclose(fileYi);
Xi = Xi';
Yi = Yi';
#write gaissian pulse datafileID = fopen('exp.txt','w');
[Pi1, frame1]  = pulsePower_frame(Xi, frame_size);
[Pi2, frame2]  = pulsePower_frame(Yi, frame_size);
figure(1)

subplot(2,2,1)
plot(t*1000, Xi, t*1000, Yi);
grid on

[Pi1_max, pi1_index] = max(Pi1);
[Pi2_max, pi2_index] = max(Pi2);
subplot(2,2,2)
plot(frame1, Pi1, frame2, Pi2);
grid on

#FFT process 
FL = L * pkt_size / frame_size; #frequency domain data length
P1f1 = fft(Pi1, FL);
P2f1 = fft(Pi2, FL);
f = (0:FL-1);

subplot(2,2,3);
plot(f, real(P1f1), f, real(P2f1));
grid on

#multiply FFT vectors
P2f2 = flip(P2f1);
PPf = P1f1.*P2f2;
PPf = ifft(PPf);
PPf = fftshift(PPf);
[peak, index] = max(PPf)
tz = (0:FL-1);
subplot(2,2,4)
plot(tz, PPf);
grid on











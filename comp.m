function y = comp(x, Threshold, CS, fs, ta, tr, tM)
% Based on
% Author: M. Holters
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

%We take in the uncompressed sampled audio signal and  the calculated
%compressor parameters
%
c = (0:7000);
t=c/fs;

% Calculate trasfer function variabls based on system timing
at = 1-(exp((-2.2)/(ta*fs)));
rt = 1-(exp((-2.2)/(tr*fs)));
tav = 1-(exp((-2.2)/(tM*fs)));

delay = 150; %delays the input signal so that calculations can be performed 
%to be applied by the time the signal gets to the gain stage

xrms = 0; % lowest possible rms value of signal x
g = 1; %Highest possible value of signal x
buffer = zeros(1,delay); % block of memory set aside to be used later to make matlab run faster
xnrms = zeros(1,length(x));
fn = zeros(1,length(x));
gn = zeros(1,length(x));
y = zeros(1,length(x));

for n = 1:length(x) %loop that looks at every sample in audio signal x
  xrms = (1-tav) * xrms + tav * x(n)^2; % calculates the rms value of the current sample
  xnrms(n)=xrms; % Store all samples of xrms as they are found on each pass through the loop
  X = 10*log10(xrms); % converts the rms value to dB 
  G = min([0, CS*(Threshold-X)]);% finds out if static gain in dB less is than 0. 
  % If X > Threshold, it returns a negative value and we need to compress. If x<
  % Threshold, it returns 0 and we don't compress
  f = 10^(G/20); %converting static gain from dB to amplitude level
  fn(n)=f;
  if f < g
    coeff = at; % If we need to compress, based on the comparison in the 
    %loop, then we make the coeff == to the attack time
  else
    coeff = rt;% % If we don't need to compress, based on the comparison in the 
    %loop, then we make the coeff == to the release time
  end;
  g = (1-coeff) * g + coeff * f; % this seems to somehow implement the attack/releasse time
  gn(n)=g;
  y(n) = g * buffer(end); % aply compression to the last element n the buffer, 
  %the delayed element that the compression claculation is based on
  
  buffer = [x(n) buffer(1:end-1)]; % puts input signal x into the buffer
 
end;
subplot(4,1,1)
plot(x)
title('Input vs Output')
xlabel('time (s)')
ylabel('Amplitude')

hold on;
plot(y, 'r-');
legend('Input', 'Output')
hold off;

subplot(4,1,2)
plot(t,10*log10(fn))
title('Static Gain')
xlabel('time (s)')
ylabel('Static Gan (dB)')

subplot(4,1,3)
plot(t,10*log10(gn))
title('Dynamic Gain')
xlabel('time (s)')
ylabel('Dynamic Gain (dB)')

subplot(4,1,4)
plot(t,10*log10(xnrms))
title('x rms')
xlabel('time (s)')
ylabel('Power (dB)')
end
function y = comp(x, Threshold, Ratio, sampling_freq, attack, release, tM,R)
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
% input_signal = (0:length(x)); % buffer to hold the input signal
t=x/sampling_freq; % time length of input signal

% make_up_gain  = abs(Threshold/R)

% Calculate transfer function variables based on system timing
attack_time = 1-(exp((-2.2)/(attack*sampling_freq))); % attack * sampling freq is 
%the number of samples that the attack time acts for 
rt = 1-(exp((-2.2)/(release*sampling_freq)));
RMS_avg_time = 1-(exp((-2.2)/(tM*sampling_freq)));

delay = 150; %delays the input signal so that calculations can be performed 
%to be applied by the time the signal gets to the gain stage

xrms = 0; % lowest possible rms value of signal x
g = 1; %Highest possible value of signal x
buffer = zeros(1,delay); % block of memory set aside to be used later to make matlab run faster
xnrms = zeros(1,length(x));
fn = zeros(1,length(x));% array to hold ??
gn = zeros(1,length(x));% array to hold ??
y = zeros(1,length(x));% array to hold Output??

for n = 1:length(x) %loop that looks at every sample in audio signal x
  xrms = (1-RMS_avg_time) * xrms + RMS_avg_time * x(n)^2; % calculates the rms value of the current sample
  xnrms(n)=xrms; % Store all samples of xrms as they are found on each pass through the loop
  X = 10*log10(xrms); % converts the rms value to dB 
  G = min([0, Ratio*(Threshold-X)]);% calculates the amount of signal above the threshold.  
  % If X > Threshold, it returns a negative value and we need to compress. If x<
  % Threshold, it returns 0 and we don't compress
  f = 10^(G/20); % undo dB's convert to amplitude in volts?converting static gain from dB to amplitude level
  fn(n)=f; %current sample == amplitude in volts
  if f < g
    coeff = attack_time; % If we need to compress, based on the comparison in the 
    %loop, then we make the coeff == to the attack time
  else
    coeff = rt;% % If we don't need to compress, based on the comparison in the 
    %loop, then we make the coeff == to the release time
  end;
  g = (1-coeff) * g + coeff * f; % this seems to somehow implement the attack/releasse time
  gn(n)=g;
  y(n) = g * buffer(end); % apply compression to the last element n the buffer, 
  %the delayed element that the compression claculation is based on
  
  buffer = [x(n) buffer(1:end-1)]; % puts input signal x into the buffer
  
end;

audiowrite('output_compressed.wav',y,sampling_freq)
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
ylabel('Static Gain (dB)')

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
 audiowrite('output.wav',y,sampling_freq);
end
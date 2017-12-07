
%Compressor main function reads in compressor parameters determined by the
%automatic process implemented in python
% the parameters determined automatically from signal analysis are
% Threshold, Ratio, Knee, Attack time and Release time
M=csvread('compressor.csv');
[audio,sampling_freq] = audioread('Snare Top_erratic.wav');
%sampling_freq=44100;    % sampling frequency
Ts=1/sampling_freq;    % sampling time
f=1000;     % frequency of sine wave
Threshold = M(1);   % Compressor threshold - the level above which the compressor
% starts to act on the signal =>****threshold is in dB*****<=
Slope = (1-(1/(M(2))));  % Compressor slope 
attack = M(3); % Attack Time - how long it takes for the signal to be fully 
%compressed after the threshold is first triggered (in seconds)
release = M(4); % Release Time - how long it takes before the signal fully 
%stops being compressed after the treshold has stopped being triggered (in
%seconds)
R = 1.63;
tM = (attack+release)/2; 
hop = 1;
input = audio(hop:hop+4096);
hop = hop+(4096);
n=(0:length(audio)); % Empty array for samples
audiowrite('input.wav',input,sampling_freq);
% simple sine wave - making a sampled sine wave at freqency 2*pi*f*n with length
% Ts
x1=sin(2*pi*f*n*Ts);

% Modify sine wave so that the amplitude changes from 1 to 2 for 0.3 < t <
% 0.6. Then after 0.6 seconds, return the amplitude back to 1.
for c=0:4096
   if (c/sampling_freq)>0.3 && (c/sampling_freq)<0.6
       x1(c) = x1(c)*2;
   end
end      

% Call compressor function to compress signal based on desired criteria.
comp(audio, Threshold, Slope, sampling_freq, attack, release, tM,R);

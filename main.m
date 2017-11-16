%Compressor main function reads in compressor parameters determined by the
%automatic process implemented in python
% the parameters determined automatically from signal analysis are
% Threshold, Ratio, Knee, Attack time and Release time


fs=8000;    % sampling frequency
Ts=1/fs;    % sampling time
f=1000;     % frequency of sine wave
CT = 1.2;   % Compressor threshold - the level above which the compressor
% starts to act on the signal
CS = 0.75;  % Compressor slope (ratio?)
ta = 0.009; % Attack Time - how long it takes for the signal to be fully 
%compressed after the threshold is first triggered
tr = 0.092; % Release Time - how long it takes before the signal fully 
%stops being compressed after the treshold has stopped being triggered
tM = 0.027; 

n=(0:7000); % Empty array for samples

% simple sine wave - making a sampled sine wave at freqency 2*pi*f*n with length
% Ts
x1=sin(2*pi*f*n*Ts);

% Modify sine wave so that the amplitude changes from 1 to 2 for 0.3 < t <
% 0.6. Then after 0.6 seconds, return the amplitude back to 1.
for c=0:7000
   if (c/fs)>0.3 && (c/fs)<0.6
       x1(c) = x1(c)*2;
   end
end      

% Call compressor function to compress signal based on desired criteria.
comp(x1, CT, CS, fs, ta, tr, tM);

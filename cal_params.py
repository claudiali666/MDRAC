import sys
import numpy as np
import soundfile as sf
from scipy.io import wavfile

def cal_ratio(data): 
	p = w_p(data)
	f = w_f(data)
    return 0.54*p+0.764*f+1

def cal_threshold(data): 
	rms = cal_rms(data)
    p = w_p(data)
    return -11.03+0.44*rms-4.987*p

def cal_knee(data):
	threshold = abs(cal_threshold(data))
	return threshold/2

def rms_amplitude(data): 
    rms_sum = 0.0
    for i in range(0, len(data)): 
        rms_sum += (data[i] * data[i])
    rms_sum /= len(data)
    return np.log10(np.sqrt(rms_sum))* 20

def spectral_centroid(data):
	x = spectral_magnitude(data)
	f = center_frequency(data)
	sum = 0.0
	x_sum = 0.0
	for i in range(0, len(data)): 
		sum += x[i]*f[i]
		x_sum += x[i]
	return sum/x_sum


def spectral_magnitude(data):
	complex_spectrum = np.fft.fft(data)
	return abs(complex_spectrum)

def center_frequency(data):
	center = np.zeros((1,len(data)))
	for n in range(0, len(data)-1)
		center[n] = (data[n]+data[n+1])/2
	return center

def spectral_spread(data):
	x = spectral_magnitude(data)
	f = center_frequency(data)
	u = spectral_centroid(data)
	sum = 0.0
	for i in range(0, len(data)):
		diff = x[i] - u 
		sum +=  np.pow(diff,2)*f[i]
	return sum

def crest_factor(data):
	peak = peak_amplitude(data)
	rms = rms_amplitude(data)
	return abs(peak)/rms
//maybe in main

def avg_crest(data, m):
	//for each track
		sum += crest_factor(data)

	return sum/m

def w_p(data):
	pow = np.pow(rms_amplitude(data) - avg_crest,2)/(2*spectral_spread(data))
	result = np.exp(pow)
	return result 
	return 2-result

def w_f(data):
	






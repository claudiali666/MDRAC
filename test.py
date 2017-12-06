import numpy as np
import soundfile as sf
import math
import scipy.io.wavfile

# input_path = '/Users/minthu/PycharmProjects/assignment1/mix_data_wave.wav'


def crest_factor(data):
    peak = peak_amplitude(data)
    rms = rms_amplitude(data)
    return abs(peak) / rms

def peak_amplitude(data):
    return np.max(data)

def rms_amplitude(data):
    rms_sum = 0.0
    for i in range(0, len(data)):
        rms_sum += (data[i] * data[i])
    rms_sum /= len(data)
    return np.sqrt(rms_sum) * np.sqrt(2.0)

def cal_attack(data):
    a_max = 0.08     # the maximum attack time is set to 80ms
    crest = crest_factor(data)
    return 2*a_max/math.pow(crest, 2)

def cal_release(data):
    r_max = 1      # the maximum release time is set to 100ms
    crest = crest_factor(data)
    return 2*r_max/math.pow(crest, 2)

# rate, data = scipy.io.wavfile.read('Hi Hats.wav')
data, rate = sf.read('Hi Hats.wav')
a = cal_attack(data)
b = cal_release(data)
print(a,b)

# def x_crest(data):
#     x_p = x_peak(data)
#     x_m = x_rms(data)
#     return abs(x_p)/x_m

# def x_rms(data):
#     sc = 0.2 # set time constant to 200ms
#     sf = 44100 # sampling frequency
#     a = math.exp(-1/sc*sf) # smoothing constant
#     x_nrms = np.zeros(1, len(data))
#     for n in range(1, len(data)):
#         x_nrms[n] = np.sqrt((1-a) * np.pow(data[n],2) + a * x_nrms[n-1])
#     return x_nrms
#
# def x_peak(data):
#     sc = 0.2 # set time constant to 200ms
#     sf = 44100 # sampling frequency
#     a = math.exp(-1/sc*sf) # smoothing constant
#     x_npeak = np.zeros(1, len(data))
#     for n in range(1, len(data)):
#         x_npeak[n] = np.sqrt(np.max(np.pow(data[n],2),((1-a) * np.pow(data[n],2)+a*np.pow(x_npeak[n-1],2))))
#     return x_nrms


import numpy as np
import soundfile as sf
import math

data, rate = sf.read('Hi Hats.wav')

def cal_attack(data):
    a_max = 0.08     # the maximum attack time is set to 80ms
    crest = x_crest(data)
    return 2*a_max/math.pow(crest, 2)

def cal_release(data):
    r_max = 1      # the maximum release time is set to 1000ms
    crest = x_crest(data)
    return 2*r_max/math.pow(crest, 2)

def x_crest(data):
    x_p = x_peak(data)
    x_m = x_rms(data)
    return abs(x_p)/x_m

def x_rms(data):
    sc = 0.2 # set time constant to 200ms
    sf = 44100 # sampling frequency
    a = math.exp(-1/sc*sf) # smoothing constant
    rms_sum = 0.0
    x_nrms = np.zeros(len(data))
    for n in range(1, len(data)):
        x_nrms[0] = 0
        x_nrms[n] = np.sqrt((1-a) * math.pow(data[n],2) + a * x_nrms[n-1])
    for i in range(0, len(data)):
        rms_sum += (x_nrms[i] * x_nrms[i])
    rms_sum /= len(data)
    return np.sqrt(rms_sum) * np.sqrt(2.0)


def x_peak(data):
    sc = 0.2 # set time constant to 200ms
    sf = 44100 # sampling frequency
    a = math.exp(-1/sc*sf) # smoothing constant
    x_npeak = np.zeros(len(data))
    for n in range(1, len(data)):
        x_npeak[0] = 0
        x_npeak[n] = np.sqrt(max(math.pow(data[n],2),((1-a) * math.pow(data[n],2)+a*math.pow(x_npeak[n-1],2))))
    return np.max(x_npeak)

print(cal_attack(data))
print(cal_release(data))




# def crest_factor(data):
#     peak = peak_amplitude(data)
#     rms = rms_amplitude(data)
#     return abs(peak) / rms
#
# def peak_amplitude(data):
#     return np.max(data)
#
# def rms_amplitude(data):
#     rms_sum = 0.0
#     for i in range(0, len(data)):
#         rms_sum += (data[i] * data[i])
#     rms_sum /= len(data)
#     return np.sqrt(rms_sum) * np.sqrt(2.0)
#
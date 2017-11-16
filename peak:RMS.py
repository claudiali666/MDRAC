import sys
import numpy as np
import soundfile as sf
from scipy.io import wavfile

def peak_amplitude(data): 
    return np.max(data)

def rms_amplitude(data): 
    rms_sum = 0.0
    for i in range(0, len(data)): 
        rms_sum += (data[i] * data[i])
    rms_sum /= len(data)
    return np.sqrt(rms_sum) * np.sqrt(2.0)

input_path = input("Enter filename: ")
data, samplerate = sf.read(input_path)

print(peak_amplitude(data))
print(rms_amplitude(data))

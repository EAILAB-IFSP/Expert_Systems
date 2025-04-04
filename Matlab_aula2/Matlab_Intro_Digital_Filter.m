% Introduction to Digital Filtering
% Ref: https://x-engineer.org/discretizing-transfer-function/
% Adapted by Dr. Arnaldo de Carvalho Jr - Abr 2025

clear all; clc; close all;

% ECG Function
function x = ecg(L)
a0 = [0,  1, 40,  1,   0, -34, 118, -99,   0,   2,  21,   2,   0,   0,   0];
d0 = [0, 27, 59, 91, 131, 141, 163, 185, 195, 275, 307, 339, 357, 390, 440];
a = a0 / max(a0);
d = round(d0 * L / d0(15));
d(15) = L;
for i = 1:14
    m = d(i) : d(i+1) - 1;
    slope = (a(i+1) - a(i)) / (d(i+1) - d(i));
    x(m+1) = a(i) + slope * (m - d(i)); %#ok<AGROW> 
end
end

% *** Compensation for Constant Filter Delay ***

% Example of Noisy Waveform (electrocardiogram)
Fs = 500;                    % Sample rate in Hz
N = 500;                     % Number of signal samples
rng default;
x = ecg(N)'+0.25*randn(N,1); % Noisy waveform
t = (0:N-1)/Fs;              % Time vector

Fnorm = 75/(Fs/2); % Normalized frequency
df4 = designfilt("lowpassiir", ...
    FilterOrder=7, ...
    PassbandFrequency=Fnorm, ...
    PassbandRipple=1, ...
    StopbandAttenuation=60);

grpdelay(df4,2048,Fs)



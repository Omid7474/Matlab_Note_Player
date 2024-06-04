clc;
clear;
close all;

%% Constants
fs = 30000; % Sampling frequency
duration = 19; % Duration in seconds
t = 0 : 1/fs : duration; % Time vector with appropriate sampling rate

% Frequencies for the middle octave of a piano (C4 to B4)
fVect = [261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, ...
         415.30, 440.00, 466.16, 493.88];

% Original note vector with indices corresponding to fVect
noteVect = [8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 4 10 10 1 4 4 4 ...
            8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 9 8 8 8 1 1 1];

% Extend note vector to cover the full duration at twice the speed
noteVect = repmat(noteVect, 1, 2);

%% Initialize output signal
y = zeros(1, length(t));

%% Note player loop
noteDuration = 0.2; % Each note lasts for 0.2 seconds 
for k = 1 : length(noteVect)
    noteIndex = noteVect(k);
    frequency = fVect(noteIndex);
    startTime = (k - 1) * noteDuration; % Start time for the current note
    endTime = startTime + noteDuration; % End time for the current note
    startIdx = round(startTime * fs) + 1;
    endIdx = round(endTime * fs);
    if endIdx > length(t)
        endIdx = length(t);
    end
    y(startIdx:endIdx) = y(startIdx:endIdx) + 2 * cos(2 * pi * frequency * t(startIdx:endIdx));
end

%% Setup echo
h = [];
n = 200; % Echo delay
m = 4; % Number of echoes
for i = 1 : m
    h = [h, [1, zeros(1, n)] / i];
end

%% Convolve the signal with echo
y = conv(y, h, 'same'); % Use 'same' to keep the same length as original signal

%% Output spectrogram and audio file
figure;
specgram(y, 320, fs);
title('Spectrogram of the signal');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

audiowrite('NoteAudio.wav', y, fs);

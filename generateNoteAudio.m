function generateNoteAudio(fs, duration, noteVect, noteDuration, outputFilename)
    % GENERATENOTEAUDIO Generates an audio file from a sequence of musical notes
    %
    % Parameters:
    %   fs - Sampling frequency (default: 30000)
    %   duration - Duration of the audio in seconds (default: 19)
    %   noteVect - Vector of note indices (default: provided below)
    %   noteDuration - Duration of each note in seconds (default: 0.2)
    %   outputFilename - Name of the output audio file (default: 'NoteAudio.wav')
    %
    % Example:
    %   generateNoteAudio(30000, 19, [8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 4 10 10 1 4 4 4 ...
    %     8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 9 8 8 8 1 1 1], 0.2, 'NoteAudio.wav');

    if nargin < 1, fs = 30000; end
    if nargin < 2, duration = 19; end
    if nargin < 3
        noteVect = [8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 4 10 10 1 4 4 4 ...
                    8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 9 8 8 8 1 1 1];
    end
    if nargin < 4, noteDuration = 0.2; end
    if nargin < 5, outputFilename = 'NoteAudio.wav'; end

    % Time vector with appropriate sampling rate
    t = 0 : 1/fs : duration;

    % Frequencies for the middle octave of a piano (C4 to B4)
    fVect = [261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, ...
             415.30, 440.00, 466.16, 493.88];

    % Extend note vector to cover the full duration at twice the speed
    noteVect = repmat(noteVect, 1, 2);

    % Initialize output signal
    y = zeros(1, length(t));

    % Note player loop
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

    % Setup echo
    h = [];
    n = 200; % Echo delay
    m = 4; % Number of echoes
    for i = 1 : m
        h = [h, [1, zeros(1, n)] / i];
    end

    % Convolve the signal with echo
    y = conv(y, h, 'same'); % Use 'same' to keep the same length as original signal

    % Output spectrogram and audio file
    figure;
    windowLength = 1024;
    noverlap = round(windowLength * 0.75);
    nfft = 2^nextpow2(windowLength);
    spectrogram(y, windowLength, noverlap, nfft, fs, 'yaxis');
    title('Spectrogram of the signal');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');

    audiowrite(outputFilename, y, fs);

    disp(['Audio file saved as: ' outputFilename]);
    disp(['Total duration: ' num2str(duration) ' seconds']);
end
%% Omidreza Davoudnia - 2020 winter
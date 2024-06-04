%
clc;
clear;
close all;

% Define parameters
fs = 30000; % Sampling frequency
duration = 19; % Duration in seconds
noteVect = [8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 4 10 10 1 4 4 4 ...
            8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 9 8 8 8 1 1 1]; % Note sequence
noteDuration = 0.2; % Duration of each note
outputFilename = 'NoteAudio.wav'; % Output file name

% Call the function to generate the audio
generateNoteAudio(fs, duration, noteVect, noteDuration, outputFilename);

disp('Note audio generation complete.');
%% Omidreza Davoudnia - 2020 winter
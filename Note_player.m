
clc
clear
close all
%% time and note vectors
t = 0 : 0.0001 :48 ;
fs = 30000;
fVect = [130 146 164 174 195 220 246 261 293 329 349 391 440 493 523 20000] /2;
noteVect = [8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 4 10 10 1 4 4 4 8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 9 8 8 8 1 1 1 8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 4 10 10 1 4 4 4 8 10 12 11 10 9 8 8 3 4 4 4 9 9 2 4 4 9 8 8 8 1 1 1];
y = zeros (1,length(t));

%% note player loop
for k=1 :0.5: 48
    a = noteVect(k*2);
    a = fVect(a);
    
 y = y + 2 *cos (2 * pi *a*t) .* rectpuls (t-k,0.5) ;  
end

%% setup echo 
h = [] ;
n = 200 ;
m = 4 ;
for i=1:m
 h = [h [1 zeros(1 , n)] /(i)];   
end


%% output block spectrogram and wav file
y = conv ( h , y );
axis ([0 , 0.02 , -2 , 2])
figure
specgram (y,320,fs)
wavwrite (y,fs,'my signal');

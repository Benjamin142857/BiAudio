[y,Fs] = audioread('1.mp3');   %??????

for i = 1:30
    x1 = y(44100*(i-1)+1: 44100*i, 1);
    x2 = y(44100*(i-1)+1: 44100*i, 2);
    sound([x1, x2], Fs); %%??
    pause(1);
end;
    
% clear sound;  %%??

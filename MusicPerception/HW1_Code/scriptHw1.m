

%Script to test all the loudness EBU values for test files. 
clear all; 

filenames = {'1kHz Sine -20 LUFS-16bit.wav', '1kHz Sine -26 LUFS-16bit.wav', '1kHz Sine -40 LUFS-16bit.wav','seq-3341-1-16bit.wav','seq-3341-2-16bit.wav','seq-3341-3-16bit-v02.wav','seq-3341-4-16bit-v02.wav', 'seq-3341-5-16bit-v02.wav'};

L = length(filenames);

% run through all the test file and print the LUFS and LU values. 
for n=1:L 
    [LUFS, LU] = LoudnessEBU(filenames{n});
    disp('The file name is ');
    filenames{n}
    fprintf('The LUFS and LU values are %f and %f respectively\n\n\n',  LUFS, LU);
end



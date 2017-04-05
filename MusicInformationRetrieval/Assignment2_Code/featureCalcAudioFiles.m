%This script is the one which goes through every song and calculates the
%10-d feature for each training point. 

blockSize = 2048;
hopSize = 1024;

genres = {'classical', 'country', 'hiphop','jazz', 'metal'};


eachGenre = [];
grandMatrixAllGenres = [];
h=waitbar(0,'Please wait..');
for i=1:5
    waitbar(i/5)
    eachGenre = [];
    for n=0:99
        file = sprintf('%s.000%02d.au', genres{i}, n);
        
        X = audioread(file);
        
        featureMatrix = GetFeatureMatrix(X, blockSize, hopSize);
        fileFeatureVec = meanStdFeatureMatrix(featureMatrix);
        
        eachGenre = [eachGenre ; fileFeatureVec]; % This is a matrix with rows = number of songs in each genre, and columns = 10;
    end
    grandMatrixAllGenres = [grandMatrixAllGenres;eachGenre]; % 100 by 10 matrices stacked on top of each other...classical, country, hiphop, jazz, metal
end




close(h);

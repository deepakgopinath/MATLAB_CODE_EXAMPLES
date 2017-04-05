%Run this script to execute different parts of assignment 2. This assumes
%that the unnormalized feature calculation has already been done on 500
%songs and the matrix has been stored in a text file. 


pause on;
disp('Normalizing and tagging of feature matrix...')
normFeatureMatrix;
disp('Press any key to continue');
pause;

disp('Single feature ranking');
rankSingleFeatures;
disp('Press any key to continue');
pause;

disp('Performing sequential forward feature selection');
sequentialFSel;
disp('Press any key to continue');
pause;

disp('Covariance matrix for 10 features');
covariance(AminusTag);
disp('Press any key to continue');
pause;


disp('Confusion Matrix for best feature subset and k = 1,3 5');
bestFeatureDifferentK;

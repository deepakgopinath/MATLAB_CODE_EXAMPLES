function  y  = WhiteNoise( length )
%WHITENOISE Uniform Distributed White Noise Generator
%   Generate white noise of length long
    
    y = unifrnd(-1,1,1,length);
end


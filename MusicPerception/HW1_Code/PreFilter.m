function [ filteredData] = PreFilter(samples)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

   samples = shelvingFilter(samples);
   filteredData = hiPassFilter(samples);
end


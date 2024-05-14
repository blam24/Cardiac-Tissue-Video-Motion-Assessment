function [avg_dist] = calc_avg_dist(vid,avg_motion)
% function description: calculates average distance in um

% function parameters
% INPUT(S):
% avg_motion: nx1 double; output from motion calculation functions
% vid: video data from VideoReader
%
% OUTPUT(S):
% avg_dist: nx1 double; in um

load('dist_per_pixel_1080.mat');

if (vid.Height==1080)
    avg_dist=avg_motion*dist_per_pixel_1080;
else
    avg_dist=avg_motion*(1080/vid.Height)*dist_per_pixel_1080;
end

end
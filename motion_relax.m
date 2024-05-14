function [avg_motion] = motion_relax(Fm,Fend,vid,saveDir)
% function description: calculates average motion for case of relaxation only

% function parameters
% INPUT(S):
% Fm: contraction state frame #
% Fend: resting state frame #; reference
% vid: video data from VideoReader
% saveDir: path to folder to save data in
%
% OUTPUT(S):
% avg_motion: 100x1 double; averaged magnitude motion

%% setup
frame_size=vid.width;
motion_size=ceil(frame_size/17);

%% calculate motion matrix
nFrames=Fend-Fm+1;
motion_matrix=zeros(motion_size,motion_size,nFrames);

frameRef=read(vid,Fend);
imgRef=rgb2gray(frameRef);

for iter=1:nFrames
    frameCurr=read(vid,(Fm+iter-1));
    imgCurr=rgb2gray(frameCurr);
    hbm=vision.BlockMatcher('ReferenceFrameSource','Input port');
    motion_matrix(:,:,iter)=hbm(imgRef,imgCurr);    
end

%% calculate average motion
avg_motion=zeros(nFrames,1);

for i=1:nFrames
   avg_motion(i)=mean2(motion_matrix(:,:,i));
end

%% save data
save([saveDir,'\avg_motion.mat'],'avg_motion');

end
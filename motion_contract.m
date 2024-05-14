function [avg_motion] = motion_contract(F0,Fm,vid,saveDir)
% function description: calculates average motion for case of contraction only

% function parameters
% INPUT(S):
% F0: relaxation state frame #; reference
% Fm: contraction state frame #
% vid: video data from VideoReader
% saveDir: path to folder to save data in
%
% OUTPUT(S):
% avg_motion: nx1 double; averaged magnitude motion

%% setup
frame_size=vid.width;
motion_size=ceil(frame_size/17);

%% calculate motion matrix
nFrames=Fm-F0+1;
motion_matrix=zeros(motion_size,motion_size,nFrames);

frameRef=read(vid,F0);
imgRef=rgb2gray(frameRef);

for iter=1:nFrames
    frameCurr=read(vid,(F0+iter-1));
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
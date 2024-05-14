function [avg_motion] = motion_contract_relax_contract(Fend,F0,Fm,saveDir_curr,vid,saveDir)
% function description: calculates average motion for case of cardiomyocytes at rest -> contract -> go back to rest; 1 cycle

% function parameters
% INPUT(S):
% Fend: end resting state frame # of 1st cycle
% F0: resting state frame # of subsequent cycle
% Fm: contracted frame # subsequent cycle
% vid: video data from VideoReader
% saveDir: path to folder to save data in
%
% OUTPUT(S):
% avg_motion: nx1 double; averaged magnitude motion

%% setup
frame_size=vid.width;
motion_size=ceil(frame_size/17);

%% calculate motion matrix
nFrames=Fm;
motion_matrix=zeros(motion_size,motion_size,nFrames);

refNum=round(mean([Fend F0]));
frameRef=read(vid,refNum);
imgRef=rgb2gray(frameRef);

for iter=1:nFrames
    frameCurr=read(vid,(iter));
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
function motion_stats = time_relax(avg_motion,saveDir)
% function description: calculates cycle time (s) from contracted to relaxed states

% function parameters
% INPUT(S):
% avg_motion: nx1 double; averaged magnitude of motion
% saveDir: path to folder to save data in
%
% OUTPUT(S):
% motion_stats: struct with following fields
%       time_cr: time to go from contracted to relaxed state (s)
%       maxIndex: frame # for contracted state
%       minIndex: frame # for relaxed state following contraction

% determine reference value and index for contracted state
[maxVal,maxIndex]=max(avg_motion);
refVal=maxVal*0.05;

% set up parameters
minIndex=nan;

% determine indices for relaxed states
for iter=1:(length(avg_motion)-maxIndex)
    if (avg_motion(maxIndex+iter)<refVal)
        minIndex=maxIndex+iter;
        break
    end
end

% calculate contraction and relaxation times
if (isnan(minIndex))
    time_cr=nan;
else
   time_cr=(minIndex-maxIndex)*0.02;
end

% save data in struct
motion_stats.time_cr=time_cr;
motion_stats.maxIndex=maxIndex;
motion_stats.minIndex=minIndex;
save([saveDir,'\motion_stats.mat'],'motion_stats');

% plot figure
figure;plot(1:length(avg_motion),avg_motion)
hold on
plot(maxIndex,avg_motion(maxIndex),'*');
if (isnan(minIndex))
    warning(['nan value, minIndex, analysis for:',saveDir]);
else
    plot(minIndex,avg_motion(minIndex),'*');
end
title('average motion w/ marked cutoff points');
hold off
savefig([saveDir,'\avg_motion']);

end
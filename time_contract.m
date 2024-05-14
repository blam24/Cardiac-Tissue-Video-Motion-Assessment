function motion_stats = time_contract(avg_motion,saveDir)
% function description: calculates cycle time (s) from relaxed to contracted to relaxed state

% function parameters
% INPUT(S):
% avg_motion: nx1 double; averaged magnitude of motion
% saveDir: path to folder to save data in
%
% OUTPUT(S):
% motion_stats: struct with following fields
%       time_rc: time to go from relaxed to contracted state (s)
%       minIndex: frame # of original relaxed state
%       maxIndex: frame # for contracted state

% determine reference value and index for contracted state
[maxVal,maxIndex]=max(avg_motion);
refVal=maxVal*0.05;

% set up parameters
minIndex=nan;

% determine indices for relaxed states
for iter=1:maxIndex-1
    if (avg_motion(maxIndex-iter)<refVal)
        minIndex=maxIndex-iter;
        break
    end
end

% calculate contraction and relaxation times
if (isnan(minIndex))
    time_rc=nan;
else
    time_rc=(maxIndex-minIndex)*0.02;
end

% save data in struct
motion_stats.time_rc=time_rc;
motion_stats.minIndex=minIndex;
motion_stats.maxIndex=maxIndex;
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
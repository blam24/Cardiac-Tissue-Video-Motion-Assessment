function motion_stats = time_rcr(avg_motion,saveDir)
% function description: calculates cycle time (s) from relaxed to contracted to relaxed state

% function parameters
% INPUT(S):
% avg_motion: nx1 double; averaged magnitude of motion
% saveDir: path to folder to save data in
%
% OUTPUT(S):
% motion_stats: struct with following fields
%    time_rc: time to go from relaxed to contracted state (s)
%    time_cr: time to go from contracted to relaxed state (s)
%    minIndex1: frame # of original relaxed state
%    maxIndex: frame # for contracted state
%    minIndex2: frame # for relaxed state following contraction

% determine reference value and index for contracted state
[maxVal,maxIndex]=max(avg_motion);
refVal=maxVal*0.05;

% set up parameters
minIndex1=nan;
minIndex2=nan;

% determine indices for relaxed states
for iter=1:maxIndex-1
    if (avg_motion(maxIndex-iter)<refVal)
        minIndex1=maxIndex-iter;
        break
    end
end

for iter=1:(length(avg_motion)-maxIndex)
    if (avg_motion(maxIndex+iter)<refVal)
        minIndex2=maxIndex+iter;
        break
    end
end

% calculate contraction and relaxation times
if (isnan(minIndex1))
    time_rc=nan;
else
    time_rc=(maxIndex-minIndex1)*0.02;
end

if (isnan(minIndex2))
    time_cr=nan;
else
   time_cr=(minIndex2-maxIndex)*0.02;
end

% save data in struct
motion_stats.time_rc=time_rc;
motion_stats.time_cr=time_cr;
motion_stats.minIndex1=minIndex1;
motion_stats.maxIndex=maxIndex;
motion_stats.minIndex2=minIndex2;
save([saveDir,'\motion_stats.mat'],'motion_stats');

% plot figure
figure;plot(1:length(avg_motion),avg_motion)
hold on
plot(maxIndex,avg_motion(maxIndex),'*');
if (isnan(minIndex1))
    warning(['nan value, minIndex1, analysis for:',saveDir]);
else
    plot(minIndex1,avg_motion(minIndex1),'*');
end
if (isnan(minIndex2))
    warning(['nan value, minIndex2, analysis for:',saveDir]);
else
    plot(minIndex2,avg_motion(minIndex2),'*');
end
title('average motion w/ marked cutoff points');
hold off
savefig([saveDir,'\avg_motion']);

end
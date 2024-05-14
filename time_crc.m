function motion_stats = time_crc(avg_motion,saveDir)
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
%    maxIndex1: frame # for 1st contracted state
%    minIndex1: frame # of 1st relaxed state
%    minIndex2: frame # for relaxed state preceding 2nd cycle
%    maxIndex2: frame # for 2nd contracted state

% determine max indices
[maxVal1,maxIndex1]=max(avg_motion(1:round(length(avg_motion)/2)));
[maxVal2,maxIndex2]=max(avg_motion(round(length(avg_motion)/2):end));
maxIndex2=maxIndex2+round(length(avg_motion)/2)-1;

% calculate reference value
maxVal=max([maxVal1 maxVal2]);
refVal=maxVal*0.05;

% set up parameters
minIndex1=nan;
minIndex2=nan;

% determine indices for relaxed states
for iter=1:(length(avg_motion)-maxIndex1)
    if (avg_motion(maxIndex1+iter)<refVal)
        minIndex1=maxIndex1+iter;
        break
    end
end

for iter=1:maxIndex2-1
    if (avg_motion(maxIndex2-iter)<refVal)
        minIndex2=maxIndex2-iter;
        break
    end
end

% calculate contraction and relaxation times
if (isnan(minIndex1))
    time_rc=nan;
else
    time_rc=(maxIndex2-minIndex2)*0.02;
end

if (isnan(minIndex2))
    time_cr=nan;
else
   time_cr=(minIndex1-maxIndex1)*0.02;
end

% save data in struct
motion_stats.time_rc=time_rc;
motion_stats.time_cr=time_cr;
motion_stats.maxIndex1=maxIndex1;
motion_stats.minIndex1=minIndex1;
motion_stats.minIndex2=minIndex2;
motion_stats.maxIndex2=maxIndex2;
save([saveDir,'\motion_stats.mat'],'motion_stats');

% plot figure CHECK
figure;plot(1:length(avg_motion),avg_motion)
hold on
plot(maxIndex1,avg_motion(maxIndex1),'*');
plot(maxIndex2,avg_motion(maxIndex2),'*');
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
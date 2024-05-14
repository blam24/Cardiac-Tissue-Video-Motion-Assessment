%%%%%%%%%%%%%%%%%%% MASTER SCRIPT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REQUIRES the following scripts:
%   motion_relax_contract_relax.m
%   time_rcr.m
%   motion_relax.m
%   time_relax.m
%   motion_contract.m
%   time_contract.m
%   motion_contract_relax_contract.m
%   time_crc.m
%   calc_avg_dist.m
%   
% function parameters
% INPUT(S):
% none
%
% OUTPUT(S):
% none - automatically analyzes and saves analyzed data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% select which day's data to analyze [CHANGE]
D='D28';
% options:
% 'D0','D1','D2','D3','D4','D5','D6','D7','D8','D10',...
% 'D12','D14','D16','D18','D20','D23','D26','D28'

%% retrieve correct spreadsheet ranges based on day
switch D
    case 'D0'
        excelRange='B3:F23';
    case 'D1'
        excelRange='G3:K23';
    case 'D2'
        excelRange='L3:P23';
    case 'D3'
        excelRange='Q3:U23';
    case 'D4'
        excelRange='V3:Z23';
    case 'D5'
        excelRange='AA3:AE23';
    case 'D6'
        excelRange='AF3:AJ23';
    case 'D7'
        excelRange='AK3:AO23';
    case 'D8'
        excelRange='AP3:AT23';
    case 'D10'
        excelRange='AU3:AY23';
    case 'D12'
        excelRange='AZ3:BD23';
    case 'D14'
        excelRange='BE3:BI23';
    case 'D16'
        excelRange='BJ3:BN23';
    case 'D18'
        excelRange='BO3:BS23';
    case 'D20'
        excelRange='BT3:BX23';
    case 'D23'
        excelRange='BY3:CC23';
    case 'D26'
        excelRange='CD3:CH23';
    case 'D28'
        excelRange='CI3:CM23';
    otherwise
        warning('Invalid day for data analysis');
        return;
end

% read from excel file
vidnotes=readcell('Video Annotations.xlsx','Range',excelRange);
vidnotes(cellfun(@(x) any(ismissing(x)),vidnotes))={char.empty};

%% set up save and data folders
saveDir_root=['Connexin,',D];
mkdir(saveDir_root);

selPath=uigetdir;
dataDir_root=[selPath,'\',D,' Connexin'];

%% loop through vidnotes spreadsheet
% initialize variables
load('title_list.mat');
avg_motion=[];
avg_dist=[];
vid=[];

% loop through different tissue video data from same specified day
for iter=1:21
    % set up save folder
    saveDir_curr=[saveDir_root,'\',cell2mat(title_list(iter))];
    mkdir(saveDir_curr);
    
    % import current video
    curr_region=char(title_list(iter));
%     vidPath=[dataDir_root,'\',curr_region,'.AVI'];    % for AVI
    vidPath=[dataDir_root,'\',curr_region,'.tif'];      % for tif
    
    for iter_vid=1:100      % for tif
        vid(:,:,iter_vid)=imread(vidPath,iter_vid);
    end
    
%     vid=imread(vidPath);          % for AVI
    
    % read relevant frame info
    F0=cell2mat(vidnotes(iter,2));
    Fm=cell2mat(vidnotes(iter,3));
    Fend=cell2mat(vidnotes(iter,4));
    F0=1;
    Fend=100;

    % check which of 4 cases to analyze motion for based on notes in spreadsheet
    switch cell2mat(vidnotes(iter,5))
%     POSSIBLE OPTIONS:
%     motion_case='contract only';
%     motion_case='relax only';
%     motion_case='relax-contract';
%     motion_case='';       (relax-contract-relax)
%     motion_case='no beat';
        case ''
            avg_motion=motion_relax_contract_relax(F0,Fend,vid,saveDir_curr);
            motion_stats=time_rcr(avg_motion,saveDir_curr);
            
        case 'relax only'
            avg_motion=motion_relax(Fm,Fend,vid,saveDir_curr);
            motion_stats=time_relax(avg_motion,saveDir_curr);
            
        case 'contract only'
            avg_motion=motion_contract(F0,Fm,vid,saveDir_curr);
            motion_stats=time_contract(avg_motion,saveDir_curr);
            
        case 'relax-contract'
            avg_motion=motion_contract_relax_contract(Fend,F0,Fm,vid,saveDir_curr);
            motion_stats=time_crc(avg_motion,saveDir_curr);            
            
        case 'no beat'
            disp('no beat - no calculations performed');
            return;
            
        otherwise
            warning(['Invalid Note:',cell2mat(vidnotes(iter,5))]);
            return;
    end
    
    % calculate and plot average distance
    avg_dist=calc_avg_dist(vid,avg_motion);
    save([saveDir_curr,'\avg_dist.mat'],'avg_dist');

    figure;plot(1:length(avg_dist),avg_dist)
    title('average distance (\mum)');
    savefig([saveDir_curr,'\avg_dist']);
    
    close all;
end
    
%% Project 1 - animation of head direction (HD) cell activity (2 cells - drifty)

% This code will generate an animation illustrating the activity of 2 HD
% cells recorded in freely moving rats.  One cell (cell1; top panel) was
% recorded from the retrosplenial cortex in an unmanipulated rat.  The
% other cell (cell2; bottom panel) was recorded by Will Butler from the
% anterior thalamus.  This recording was performed under dark conditions
% during an optogenetic manipulation that inactivated a vestibular nucleus
% in the brainstem.  This manipulation disrupts thalamic HD cells, causing
% their preferred firing direction to drift over time as if the HD network
% is no longer yoked to the rat's self motion.  A vertical line
% representing the rat's instantaneous HD will move back and forth along
% the x-axis while a histogram is plotted. Thes histogram represents the
% cumulative number of spikes recorded from each cell, plotted as a
% function of the rat's HD when the spike occurred.  Note the preferred
% firing direction drift observed in cell2.

%% cd to data folder

cd('C:\Users\f000cx7\Desktop\Analysis of Neural Data\Mehlman_Project_1\Data_files\mmtt1_2_24_2015_RSP');

%% load data files for the 2 HD cells

cell1 = importdata('mmtt1_2_24_2015_TT3_C2.read');
cell2 = importdata('WB76 2-10 s5 ST6 C1.read');

%% reformat the data struct - cell 1

data_cell1.sample = cell1.data(:,1);
data_cell1.timesec = cell1.data(:,1) * (1/60); % sampling rate = 60 Hz
data_cell1.rx = cell1.data(:,2);
data_cell1.ry = cell1.data(:,3);
data_cell1.gx = cell1.data(:,4);
data_cell1.gy = cell1.data(:,5);
data_cell1.HD = cell1.data(:,10);
data_cell1.cell1 = cell1.data(:,6); % # spikes per sample

%% reformat the data struct - cell 2

data_cell2.sample = cell2.data(:,1);
data_cell2.timesec = cell2.data(:,1) * (1/60); % sampling rate = 60 Hz
data_cell2.rx = cell2.data(:,2);
data_cell2.ry = cell2.data(:,3);
data_cell2.gx = cell2.data(:,4);
data_cell2.gy = cell2.data(:,5);
data_cell2.HD = cell2.data(:,10);
data_cell2.cell2 = cell2.data(:,6); % # spikes per sample

%% remove nondetects (255,0) - cell 1

% find indices of all samples with nondetects
nondetects_cell1 = find((data_cell1.rx == 255 & data_cell1.ry == 0) | (data_cell1.gx == 255 & data_cell1.gy == 0));

% remove all samples with nondetects
data_cell1.sample(nondetects_cell1) = [];
data_cell1.timesec(nondetects_cell1) = [];
data_cell1.rx(nondetects_cell1) = [];
data_cell1.ry(nondetects_cell1) = [];
data_cell1.gx(nondetects_cell1) = [];
data_cell1.gy(nondetects_cell1) = [];
data_cell1.HD(nondetects_cell1) = [];
data_cell1.cell1(nondetects_cell1) = [];

%% remove nondetects (255,0) - cell 2

% find indices of all samples with nondetects
nondetects_cell2 = find((data_cell2.rx == 255 & data_cell2.ry == 0) | (data_cell2.gx == 255 & data_cell2.gy == 0));

% remove all samples with nondetects
data_cell2.sample(nondetects_cell2) = [];
data_cell2.timesec(nondetects_cell2) = [];
data_cell2.rx(nondetects_cell2) = [];
data_cell2.ry(nondetects_cell2) = [];
data_cell2.gx(nondetects_cell2) = [];
data_cell2.gy(nondetects_cell2) = [];
data_cell2.HD(nondetects_cell2) = [];
data_cell2.cell2(nondetects_cell2) = [];

%% convert HD from radians to degrees

data_cell1.HD = data_cell1.HD * (360/(2*pi));
data_cell2.HD = data_cell2.HD * (360/(2*pi));

%% OPTIONAL - restrict the 10 min recording session - cell 1

% determine # of samples per minute
sampling_rate = 60; % sampling rate = 60 Hz
minute = sampling_rate*60;

% set start and end times
minute_start_cell1 = 1;
minute_end_cell1 = 6;

% note samples no longer continuous after removing nondetects
start_index_cell1 = find(data_cell1.sample == minute_start_cell1*minute); % find index of first sample
end_index_cell1 = find(data_cell1.sample == minute_end_cell1*minute); % find index of last sample

% restrict from minute_start to minute_end
data_truncate_cell1.sample = data_cell1.sample(start_index_cell1:end_index_cell1);
data_truncate_cell1.timesec = data_cell1.timesec(start_index_cell1:end_index_cell1);
data_truncate_cell1.rx = data_cell1.rx(start_index_cell1:end_index_cell1);
data_truncate_cell1.ry = data_cell1.ry(start_index_cell1:end_index_cell1);
data_truncate_cell1.gx = data_cell1.gx(start_index_cell1:end_index_cell1);
data_truncate_cell1.gy = data_cell1.gy(start_index_cell1:end_index_cell1);
data_truncate_cell1.HD = data_cell1.HD(start_index_cell1:end_index_cell1);
data_truncate_cell1.cell1 = data_cell1.cell1(start_index_cell1:end_index_cell1);

%% OPTIONAL - restrict the 8 min recording session - cell 2

% set start and end times
minute_start_cell2 = 3;
minute_end_cell2 = 8;

% note samples no longer continuous after removing nondetects
start_index_cell2 = find(data_cell2.sample == minute_start_cell2*minute); % find index of first sample
end_index_cell2 = find(data_cell2.sample == minute_end_cell2*minute); % find index of last sample

% restrict from minute_start to minute_end
data_truncate_cell2.sample = data_cell2.sample(start_index_cell2:end_index_cell2);
data_truncate_cell2.timesec = data_cell2.timesec(start_index_cell2:end_index_cell2);
data_truncate_cell2.rx = data_cell2.rx(start_index_cell2:end_index_cell2);
data_truncate_cell2.ry = data_cell2.ry(start_index_cell2:end_index_cell2);
data_truncate_cell2.gx = data_cell2.gx(start_index_cell2:end_index_cell2);
data_truncate_cell2.gy = data_cell2.gy(start_index_cell2:end_index_cell2);
data_truncate_cell2.HD = data_cell2.HD(start_index_cell2:end_index_cell2);
data_truncate_cell2.cell2 = data_cell2.cell2(start_index_cell2:end_index_cell2);

%% empty array to fill with HD during spiking

cell1_HD = [];
cell2_HD = [];

%% loop to determine HD during spiking - cell 1

% run this loop once before saving frames to determine ymax values
for i = 1:length(data_truncate_cell1.sample)
        
    % cell1
    if data_truncate_cell1.cell1(i) == 1 % if cell1 spikes once, add HD once
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
    
    elseif data_truncate_cell1.cell1(i) == 2 % if cell1 spikes twice, add HD twice
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
    
    elseif data_truncate_cell1.cell1(i) == 3 % if cell1 spikes 3 times, add HD 3 times
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        
    elseif data_truncate_cell1.cell1(i) == 4 % if cell1 spikes 4 times, add HD 4 times
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        
    % cell2
    elseif data_truncate_cell2.cell2(i) == 1 % if cell2 spikes once, add HD once
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
    
    elseif data_truncate_cell2.cell2(i) == 2 % if cell2 spikes twice, add HD twice
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
    
    elseif data_truncate_cell2.cell2(i) == 3 % if cell2 spikes 3 times, add HD 3 times
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        
    elseif data_truncate_cell2.cell2(i) == 4 % if cell2 spikes 4 times, add HD 4 times
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        
    end
    
end

%% determine ymax value for subsequent plots

% bin HD into 60 6-degree bins
bins = 0:6:354;
[cell1_n,cell1_x] = hist(cell1_HD,bins); % histogram of HD during cell1 spiking
[cell2_n,cell2_x] = hist(cell2_HD,bins); % histogram of HD during cell1 spiking

% determine ymax value
ymax_cell1 = max(cell1_n);
ymax_cell2 = max(cell2_n);

% set ymax value for HD line
ymax_HD_line_cell1 = ymax_cell1;
ymax_HD_line_cell2 = ymax_cell2;

%% loop to determine HD during spiking and generate animation

% run this loop again to plot and save frames

% set plot rate
plot_samples = 15; % plot every 15 samples (sampling rate = 60 Hz)

% counter
k = 0;

% clear
cell1_HD = [];
cell2_HD = [];

for i = 1:length(data_truncate_cell1.sample)
        
    % cell1
    if data_truncate_cell1.cell1(i) == 1 % if cell1 spikes once, add HD once
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
    
    elseif data_truncate_cell1.cell1(i) == 2 % if cell1 spikes twice, add HD twice
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
    
    elseif data_truncate_cell1.cell1(i) == 3 % if cell1 spikes 3 times, add HD 3 times
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        
    elseif data_truncate_cell1.cell1(i) == 4 % if cell1 spikes 4 times, add HD 4 times
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate_cell1.HD(i);
        
    % cell2
    elseif data_truncate_cell2.cell2(i) == 1 % if cell2 spikes once, add HD once
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
    
    elseif data_truncate_cell2.cell2(i) == 2 % if cell2 spikes twice, add HD twice
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
    
    elseif data_truncate_cell2.cell2(i) == 3 % if cell2 spikes 3 times, add HD 3 times
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        
    elseif data_truncate_cell2.cell2(i) == 4 % if cell2 spikes 4 times, add HD 4 times
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate_cell2.HD(i);
        
    end

% advance counter
k = k + 1;

if k == plot_samples

% plot cell1 HD histogram
[cell1_n,cell1_x] = hist(cell1_HD,bins); % histogram of HD during cell1 spiking (cumulative)

subplot(2,1,1);
set(gcf,'Color','k','Position',[100 100 600 600]);
cell1_plot = bar(cell1_x,cell1_n,'FaceColor','b','EdgeColor','none','BarWidth',1);


% x-axis properties
xlim(gca,[0 max(cell1_x)]);
set(gca,'XTick',[],'XTickLabel',[]);
xlabel('Head direction','Color','w','FontSize',14);

% y-axis properties
ylim(gca,[0 ymax_cell1]);
set(gca,'YTick',[],'YTickLabel',[]);
ylabel(gca,'Cumulative spikes','Color','w','FontSize',14);

% plot cell1 HD line
hold(gca);

x = [data_truncate_cell1.HD(i) data_truncate_cell1.HD(i)];
y = [0 ymax_HD_line_cell1];
plot(gca,x,y,'Color','k','LineWidth',5); % vertical line representing HD

% plot cell2 HD histogram
[cell2_n,cell2_x] = hist(cell2_HD,bins); % histogram of HD during cell2 spiking (cumulative)

subplot(2,1,2);
cell2_plot = bar(cell2_x,cell2_n,'FaceColor','r','EdgeColor','none','BarWidth',1);

% x-axis properties
xlim(gca,[0 max(cell2_x)]);
set(gca,'XTick',[],'XTickLabel',[]);
xlabel('Head direction','Color','w','FontSize',14);

% y-axis properties
ylim(gca,[0 ymax_cell2]);
set(gca,'YTick',[],'YTickLabel',[]);
ylabel(gca,'Cumulative spikes','Color','w','FontSize',14);

% plot cell2 HD line
hold(gca);

x = [data_truncate_cell2.HD(i) data_truncate_cell2.HD(i)];
y = [0 ymax_HD_line_cell2];
plot(gca,x,y,'Color','k','LineWidth',5); % vertical line representing HD

% save frame
frames(i/plot_samples) = getframe(gcf);

% clear figure
clf;

% reset counter;
k = 0;

end

end

%% export frames as .avi movie file

cd('C:\Users\f000cx7\Desktop\Analysis of Neural Data\Mehlman_Project_1');

% frame rate
realtime = 60 / plot_samples; % sampling rate = 60 Hz

% export
movie2avi(frames,'HD_2cell_drifty_animation_15samples4X.avi','compression','xvid','fps',realtime*4); % movie at 4X real time

% this script was developed on a machine running MATLAB R2014a and Mac OS X
% 10.7.5

% once finalized, this script was executed on a different machine running
% MATLAB R2012a and Windows 7 to utilize the xvid compression option (no
% compression options are available when running Mac OS X 10.7.5)
%% Project 1 - animation of head direction (HD) cell activity (1 cell)

% This code will generate an animation illustrating the activity of a HD
% cell recorded in the retrosplenial cortex (RSP) of a freely moving rat.
% A vertical line representing the rat's instantaneous HD will move back
% and forth along the x-axis while a histogram is plotted.  This histogram
% represents the cumulative number of spikes recorded from the cell,
% plotted as a function of the rat's HD when the spike occurred.

%% cd to data folder

cd('C:\Users\f000cx7\Desktop\Analysis of Neural Data\Mehlman_Project_1\Data_files\mmtt1_2_24_2015_RSP');

%% load data file for a HD cell recorded in the RSP for 10 min

cell1 = importdata('mmtt1_2_24_2015_TT3_C2.read');

%% reformat the data struct

data.sample = cell1.data(:,1);
data.timesec = cell1.data(:,1) * (1/60); % sampling rate = 60 Hz
data.rx = cell1.data(:,2);
data.ry = cell1.data(:,3);
data.gx = cell1.data(:,4);
data.gy = cell1.data(:,5);
data.HD = cell1.data(:,10);
data.cell1 = cell1.data(:,6); % # spikes per sample

%% remove nondetects (255,0)

% find indices of all samples with nondetects
nondetects = find((data.rx == 255 & data.ry == 0) | (data.gx == 255 & data.gy == 0));

% remove all samples with nondetects
data.sample(nondetects) = [];
data.timesec(nondetects) = [];
data.rx(nondetects) = [];
data.ry(nondetects) = [];
data.gx(nondetects) = [];
data.gy(nondetects) = [];
data.HD(nondetects) = [];
data.cell1(nondetects) = [];

%% convert HD from radians to degrees

data.HD = data.HD * (360/(2*pi));

%% OPTIONAL - restrict the 10 min recording session

% determine # of samples per minute
sampling_rate = 60; % sampling rate = 60 Hz
minute = sampling_rate*60;

% set start and end times
minute_start = 1;
minute_end = 6;

% note samples no longer continuous after removing nondetects
start_index = find(data.sample == minute_start*minute); % find index of first sample
end_index = find(data.sample == minute_end*minute); % find index of last sample

% restrict from minute_start to minute_end
data_truncate.sample = data.sample(start_index:end_index);
data_truncate.timesec = data.timesec(start_index:end_index);
data_truncate.rx = data.rx(start_index:end_index);
data_truncate.ry = data.ry(start_index:end_index);
data_truncate.gx = data.gx(start_index:end_index);
data_truncate.gy = data.gy(start_index:end_index);
data_truncate.HD = data.HD(start_index:end_index);
data_truncate.cell1 = data.cell1(start_index:end_index);

%% empty array to fill with HD during spiking

cell1_HD = [];

%% loop to determine HD during spiking

% run this loop once before saving frames to determine ymax values
for i = 1:length(data_truncate.sample)
        
    % cell1
    if data_truncate.cell1(i) == 1 % if cell1 spikes once, add HD once
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
    
    elseif data_truncate.cell1(i) == 2 % if cell1 spikes twice, add HD twice
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
    
    elseif data_truncate.cell1(i) == 3 % if cell1 spikes 3 times, add HD 3 times
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        
    elseif data_truncate.cell1(i) == 4 % if cell1 spikes 4 times, add HD 4 times
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        
    end
    
end

%% determine ymax value for subsequent plots

% bin HD into 60 6-degree bins
bins = 0:6:354;
[cell1_n,cell1_x] = hist(cell1_HD,bins); % histogram of HD during cell1 spiking

% determine ymax value
ymax_cell1 = max(cell1_n);

% set ymax value for HD line
ymax_HD_line = ymax_cell1;

%% loop to determine HD during spiking and generate animation

% run this loop again to plot and save frames

% set plot rate
plot_samples = 15; % plot every 15 samples (sampling rate = 60 Hz)

% counter
k = 0;

% clear
cell1_HD = [];

for i = 1:length(data_truncate.sample)
        
    % cell1
    if data_truncate.cell1(i) == 1 % if cell1 spikes once, add HD once
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
    
    elseif data_truncate.cell1(i) == 2 % if cell1 spikes twice, add HD twice
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
    
    elseif data_truncate.cell1(i) == 3 % if cell1 spikes 3 times, add HD 3 times
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        
    elseif data_truncate.cell1(i) == 4 % if cell1 spikes 4 times, add HD 4 times
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        cell1_HD(length(cell1_HD)+1) = data_truncate.HD(i);
        
    end

% advance counter
k = k + 1;

if k == plot_samples

% plot cell1 and cell2 HD histograms
[cell1_n,cell1_x] = hist(cell1_HD,bins); % histogram of HD during cell1 spiking (cumulative)

cell1_plot = bar(cell1_x,cell1_n,'FaceColor','b','EdgeColor','none','BarWidth',1);
set(gcf,'Color','k','Position',[100 100 500 500]);
box(gca,'off');

% x-axis properties
xlim(gca,[0 max(cell1_x)]);
set(gca,'XTick',[],'XTickLabel',[]);
xlabel('Head direction','Color','w','FontSize',16);

% y-axis properties
ylim(gca,[0 ymax_cell1]);
set(gca,'YTick',[],'YTickLabel',[]);
ylabel(gca,'Cumulative spikes','Color','w','FontSize',16);

% plot HD line
hold(gca);

x = [data_truncate.HD(i) data_truncate.HD(i)];
y = [0 ymax_HD_line];
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
movie2avi(frames,'HD_1cell_animation_15samples4X.avi','compression','xvid','fps',realtime*4); % movie at 4X real time

% this script was developed on a machine running MATLAB R2014a and Mac OS X
% 10.7.5

% once finalized, this script was executed on a different machine running
% MATLAB R2012a and Windows 7 to utilize the xvid compression option (no
% compression options are available when running Mac OS X 10.7.5)
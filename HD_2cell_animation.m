%% Project 1 - animation of head direction (HD) cell activity (2 cells)

% This code will generate an animation illustrating the activity of two HD
% cells simultaneously recorded in the postsubiculum (PoS) of a freely
% moving rat.  A vertical line representing the rat's instantaneous HD will
% move back and forth along the x-axis while two histograms are plotted.
% These histograms represent the cumulative number of spikes recorded from
% each of the two cells, plotted as a function of the rat's HD when the
% spike occurred.

%% cd to data folder

cd('C:\Users\f000cx7\Desktop\Analysis of Neural Data\Mehlman_Project_1\Data_files\mm44_8_24_2014_PoS');

%% load data files for 2 HD cells simultaneously recorded in the PoS for 20 min

cell1 = importdata('mm44 8-24 s1 TT4 C3.read');
cell2 = importdata('mm44 8-24 s1 TT1 C1.read');

%% merge data files into a single struct

data.sample = cell1.data(:,1);
data.timesec = cell1.data(:,1) * (1/60); % sampling rate = 60 Hz
data.rx = cell1.data(:,2);
data.ry = cell1.data(:,3);
data.gx = cell1.data(:,4);
data.gy = cell1.data(:,5);
data.HD = cell1.data(:,10);
data.cell1 = cell1.data(:,6); % # spikes per sample
data.cell2 = cell2.data(:,6); % # spikes per sample

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
data.cell2(nondetects) = [];

%% convert HD from radians to degrees

data.HD = data.HD * (360/(2*pi));

%% OPTIONAL - restrict the 20 min recording session

% determine # of samples per minute
sampling_rate = 60; % sampling rate = 60 Hz
minute = sampling_rate*60;

% set start and end times
minute_start = 8;
minute_end = 14;

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
data_truncate.cell2 = data.cell2(start_index:end_index);

%% empty arrays to fill with HD during spiking

cell1_HD = [];
cell2_HD = [];

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
    
    % cell2
    elseif data_truncate.cell2(i) == 1 % if cell2 spikes once, add HD once
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
    
    elseif data_truncate.cell2(i) == 2 % if cell2 spikes twice, add HD twice
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
    
    elseif data_truncate.cell2(i) == 3 % if cell2 spikes 3 times, add HD 3 times
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        
    elseif data_truncate.cell2(i) == 4 % if cell2 spikes 4 times, add HD 4 times
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        
    end
    
end

%% determine ymax values for subsequent plots

% bin HD into 60 6-degree bins
bins = 0:6:354;
[cell1_n,cell1_x] = hist(cell1_HD,bins); % histogram of HD during cell1 spiking
[cell2_n,cell2_x] = hist(cell2_HD,bins); % histogram of HD during cell2 spiking

% determine ymax values
ymax_cell1 = max(cell1_n);
ymax_cell2 = max(cell2_n);

% set ymax values for HD line
if  ymax_cell1 > ymax_cell2
    ymax_HD_line = ymax_cell1;
    ymax_HD_axis = 1;
else
    ymax_HD_line = ymax_cell2;
    ymax_HD_axis = 2;
end

%% loop to determine HD during spiking and generate animation

% run this loop again to plot and save frames

% set plot rate
plot_samples = 15; % plot every 15 samples (sampling rate = 60 Hz)

% counter
k = 0;

% clear
cell1_HD = [];
cell2_HD = [];

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
    
    % cell2
    elseif data_truncate.cell2(i) == 1 % if cell2 spikes once, add HD once
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
    
    elseif data_truncate.cell2(i) == 2 % if cell2 spikes twice, add HD twice
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
    
    elseif data_truncate.cell2(i) == 3 % if cell2 spikes 3 times, add HD 3 times
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        
    elseif data_truncate.cell2(i) == 4 % if cell2 spikes 4 times, add HD 4 times
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        cell2_HD(length(cell2_HD)+1) = data_truncate.HD(i);
        
    end

% advance counter
k = k + 1;

if k == plot_samples

% plot cell1 and cell2 HD histograms
[cell1_n,cell1_x] = hist(cell1_HD,bins); % histogram of HD during cell1 spiking (cumulative)
[cell2_n,cell2_x] = hist(cell2_HD,bins); % histogram of HD during cell2 spiking (cumulative)

[hist_axis,cell1_plot,cell2_plot] = plotyy(cell1_x,cell1_n,cell2_x,cell2_n,'bar');
set(gcf,'Color','k','Position',[100 100 500 500]);
set(cell1_plot,'FaceColor','b','EdgeColor','none','BarWidth',1);
set(cell2_plot,'FaceColor','r','EdgeColor','none','BarWidth',1);
box(hist_axis(1),'off');
box(hist_axis(2),'off');

% x-axis properties
xlim(hist_axis(1),[0 max(cell1_x)]);
xlim(hist_axis(2),[0 max(cell2_x)]);
set(hist_axis(1),'XTick',[],'XTickLabel',[]);
set(hist_axis(2),'XTick',[],'XTickLabel',[]);
xlabel('Head direction','Color','w','FontSize',16);

% y-axis properties
ylim(hist_axis(1),[0 ymax_cell1]);
ylim(hist_axis(2),[0 ymax_cell2]);
set(hist_axis(1),'YTick',[],'YTickLabel',[]);
set(hist_axis(2),'YTick',[],'YTickLabel',[]);
ylabel(hist_axis(1),'Cell 1 cumulative spikes','Color','w','FontSize',16);
ylabel(hist_axis(2),'Cell 2 cumulative spikes','Color','w','FontSize',16);

% plot HD line
hold(hist_axis(1)); 
hold(hist_axis(2));

x = [data_truncate.HD(i) data_truncate.HD(i)];
y = [0 ymax_HD_line];
plot(hist_axis(ymax_HD_axis),x,y,'Color','k','LineWidth',5); % vertical line representing HD

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
movie2avi(frames,'HD_2cell_animation_15samples4X.avi','compression','xvid','fps',realtime*4); % movie at 4X real time

% this script was developed on a machine running MATLAB R2014a and Mac OS X
% 10.7.5

% once finalized, this script was executed on a different machine running
% MATLAB R2012a and Windows 7 to utilize the xvid compression option (no
% compression options are available when running Mac OS X 10.7.5)
%% Project 1 - animation of place cell activity (5 cells)

% This code will generate an animation illustrating the activity of five
% place cells simultaneously recorded in the parasubiculum (PaS) of a
% freely moving rat.  A black line representing the rat's instantaneous
% location and past trajectory will be plotted.  Additionally, a mark will
% be plotted at every location in which a cell fires, with each cell
% represented by a different colored mark.

%% cd to data folder

cd('C:\Users\f000cx7\Desktop\Analysis of Neural Data\Mehlman_Project_1\Data_files\mm44_8_29_2014_PaS');

%% load data files for 5 place cells simultaneously recorded in the PaS for 20 min

cell1 = importdata('mm44 8-29 s2 TT1 C1.read');
cell2 = importdata('mm44 8-29 s2 TT4 C1.read');
cell3 = importdata('mm44 8-29 s2 TT2 C6.read');
cell4 = importdata('mm44 8-29 s2 TT2 C1.read');
cell5 = importdata('mm44 8-29 s2 TT2 C10.read');

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
data.cell3 = cell3.data(:,6); % # spikes per sample
data.cell4 = cell4.data(:,6); % # spikes per sample
data.cell5 = cell5.data(:,6); % # spikes per sample

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
data.cell3(nondetects) = [];
data.cell4(nondetects) = [];
data.cell5(nondetects) = [];

%% OPTIONAL - restrict the 20 min recording session

% determine # of samples per minute
sampling_rate = 60; % sampling rate = 60 Hz
minute = sampling_rate*60;

% set start and end times
minute_start = 10;
minute_end = 20;

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
data_truncate.cell3 = data.cell3(start_index:end_index);
data_truncate.cell4 = data.cell4(start_index:end_index);
data_truncate.cell5 = data.cell5(start_index:end_index);

%% empty arrays to fill with location during spiking

cell1_rx = [];
cell1_ry = [];
cell2_rx = [];
cell2_ry = [];
cell3_rx = [];
cell3_ry = [];
cell4_rx = [];
cell4_ry = [];
cell5_rx = [];
cell5_ry = [];

%% loop to determine location during spiking and generate animation

% set plot rate
plot_samples = 30; % plot every 30 samples (sampling rate = 60 Hz)

% counter
k = 0;

for i = 1:length(data.sample)
        
    % cell1
    if data.cell1(i) >= 1 % if cell1 spikes, add rx and ry
        cell1_rx(length(cell1_rx)+1) = data.rx(i,1);
        cell1_ry(length(cell1_ry)+1) = data.ry(i,1);
    
    % cell2
    elseif data.cell2(i) >= 1 % if cell2 spikes, add rx and ry
        cell2_rx(length(cell2_rx)+1) = data.rx(i,1);
        cell2_ry(length(cell2_ry)+1) = data.ry(i,1);
    
    % cell3
    elseif data.cell3(i) >= 1 % if cell3 spikes, add rx and ry
        cell3_rx(length(cell3_rx)+1) = data.rx(i,1);
        cell3_ry(length(cell3_ry)+1) = data.ry(i,1);
    
    % cell4
    elseif data.cell4(i) >= 1 % if cell4 spikes, add rx and ry
        cell4_rx(length(cell4_rx)+1) = data.rx(i,1);
        cell4_ry(length(cell4_ry)+1) = data.ry(i,1);
    
    % cell5
    elseif data.cell5(i) >= 1 % if cell5 spikes, add rx and ry
        cell5_rx(length(cell5_rx)+1) = data.rx(i,1);
        cell5_ry(length(cell5_ry)+1) = data.ry(i,1);        
        
    end

% advance counter
k = k + 1;

if k == plot_samples

% plot animal path
plot(data.rx(1:i),data.ry(1:i),'LineWidth',1,'Color','k');
set(gcf,'Color','k','Position',[100 100 500 500]);
set(gca,'Color',[0.75 0.75 0.75],'XTick',[],'XTickLabel',[],'YTick',[],'YTickLabel',[]);
box(gca,'off');
axis([0 255 0 255]);
hold on

% plot cell1 spike locations
scatter(cell1_rx,cell1_ry,40,'c','filled','MarkerEdgeColor','c');

% plot cell2 spike locations
scatter(cell2_rx,cell2_ry,40,'b','filled','MarkerEdgeColor','b');

% plot cell3 spike locations
scatter(cell3_rx,cell3_ry,40,'r','filled','MarkerEdgeColor','r');

% plot cell4 spike locations
scatter(cell4_rx,cell4_ry,40,'m','filled','MarkerEdgeColor','m');

% plot cell5 spike locations
scatter(cell5_rx,cell5_ry,40,'g','filled','MarkerEdgeColor','g');

% save frame
frames(i/plot_samples) = getframe(gcf);

% clear figure
clf;

% reset counter
k = 0;

end

end

%% export frames as .avi movie file

cd('C:\Users\f000cx7\Desktop\Analysis of Neural Data\Mehlman_Project_1');

% frame rate
realtime = 60 / plot_samples; % sampling rate = 60 Hz

% export
movie2avi(frames,'Place_5cell_animation_30samples4X.avi','compression','xvid','fps',realtime*4); % movie at 4X real time

% this script was developed on a machine running MATLAB R2014a and Mac OS X
% 10.7.5

% once finalized, this script was executed on a different machine running
% MATLAB R2012a and Windows 7 to utilize the xvid compression option (no
% compression options are available when running Mac OS X 10.7.5)
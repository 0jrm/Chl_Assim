close all
clear
clc

%assume starts at 1/1/93
%plot LC contour with it!

Chl = ncread('chlorophyll_dataset.nc','Chl');
Time = ncread('chlorophyll_dataset.nc','Time');
Lon = ncread('chlorophyll_dataset.nc','Lon');
Lat = ncread('chlorophyll_dataset.nc','Lat');
chlog = log10(Chl);

[~, ~, zDim] = size(Chl);
% zDim = 1;

% Define the colorbar limits
colorbarLimits = [-2, 2];

% Create the figure and set the colorbar limits
% Define the FHD resolution
fhdWidth = 1920;
fhdHeight = 1080;

% Add date
startDateStr = '01-01-1993';
formatIn = 'dd-mmm-yyyy';
date = datenum(startDateStr,formatIn);

% Create the figure
figure('Visible', 'off', 'Position', [100, 100, fhdWidth, fhdHeight])
caxis(colorbarLimits)

% Preallocate the video object
video = VideoWriter('Chlorophyll_dataset_animation');
video.FrameRate = 20; % Set the frame rate (adjust as needed)
video.Quality = 100; % Set the video quality (adjust as needed)
video.open();

% Loop through each file
for fileNumber = 1:zDim

    fprintf('%04d/7305\n', fileNumber);

    hold on

    % Contour plot for current tile
    h = pcolor(Lon, Lat, chlog(:,:,fileNumber));
    % Remove gridlines
    set(h, 'EdgeColor', 'none');

    
    % Add colorbar
    c = colorbar;
    c.Label.String = 'log_{10} Chlorophyl';
    
    % Set the colorbar limits
    caxis(colorbarLimits);
    
    % Label axes
    xlabel('Longitude')
    ylabel('Latitude')
    % title(sprintf('Day %04d', fileNumber));
    title(datestr(date))

    date = date + 1;

    % Add frame to the video
    frame = getframe(gcf);
    writeVideo(video, frame);

    % clearvars -except colorbarLimits video fileNumber

    hold off
    % Clear the plot for the next iteration
    clf
end

% Close the video file
video.close();

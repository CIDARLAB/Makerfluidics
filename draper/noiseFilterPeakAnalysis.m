clear all
close all

%User-defined variables
inputFilePath = '/Users/ryansilva/Documents/Draper/Data/TaguchiL9/Consolidated/2.csv';
outputFilePath = '/Users/ryansilva/Documents/Draper/Data/TaguchiL9/Consolidated/2NoisePeaks.csv';
geometry = '300Wc290Hc850WsCenterTaguchi2';
expConditions = '5% By Volume';
pictureLabels = 'Frequency (MHz)'; %Example: Frequency (MHz)
stdDevCoef = 6; % Throws away all peaks below {stdDevCoef} standard deviations above the mean

%Maths
space = ' ';
M = csvread(inputFilePath,1,2);
pks =[];
locs =[];
widths =[];
proms =[];
badPeaksLoc = [];
badPeaksProm = [];
badPeaksStd = [];
smallPeaksStd = [];
oddModeFreqs = [];
evenModeFreqs = [];
xPos=[1:1:size(M,1)];
header = {'runNumber', 'pks', 'locs', 'widths', 'proms','numPeaks','indexNumber','ratio','Normalized Peak Width', 'Normalized Ratio'};
%runLabels1 = {'5mmps250mW', '5mmps500mW', '5mmps750mW', '5mmps1000mW', '25ulpmin250mW', '25ulpmin500mW', '25ulpmin750mW', '25ulpmin1000mW','10mmps250mW', '10mmps500mW', '10mmps750mW', '10mmps1000mW','50ulpmin250mW', '50ulpmin500mW', '50ulpmin750mW', '50ulpmin1000mW'};
picNum = size(M,2); %How many pictures were taken during the run
%runLabels = [1:picNum];
runLabels = [0.5:0.01:2];
freqCol = [];
iCol = [];
numPeaks = [];
ratio = [];
rowVal = 1;
fid = fopen(outputFilePath,'w');             
fprintf(fid,'%s,',header{1:end-1}); 
fprintf(fid,'%s\n',header{end});   
fclose(fid);                           
for i = 1:size(M,2)
    eval(sprintf('[pks%i, locs%i, widths%i, proms%i] = findpeaks(M(:,%i),''Annotate'',''extents'',''MinPeakWidth'',1);',i,i,i,i,i));
    eval(sprintf('peakNums = size(pks%i,1);',i));
    eval(sprintf('rowVal = rowVal + size(pks%i,1);',i));
    for j = 1:peakNums
        freqCol = [freqCol;runLabels(i)];
        numPeaks = [numPeaks;peakNums];
        iCol = [iCol;i];
    end
    %Append values to column vector
    eval(sprintf('pks=[pks;pks%i];',i));
    eval(sprintf('locs=[locs;locs%i];',i));
    eval(sprintf('widths=[widths;widths%i];',i));
    eval(sprintf('proms=[proms;proms%i];',i));
    %calculate ratio of proms vs widths
    ratio = proms ./ widths;
    normPeakWidths = widths ./ size(M,1);
    normRatio = proms ./ normPeakWidths;
end
data = [freqCol pks locs widths proms numPeaks (iCol-1) ratio normPeakWidths normRatio];

for i = 1:size(data,1)
    %toss out peaks with locs in outside fifth of data set
    if (data(i,3)<(size(M,1)/5)) | (data(i,3)>(4*(size(M,1)/5)))
        badPeaksLoc=[badPeaksLoc,i];
    end
end
data(badPeaksLoc,:)=[];
%Count the number of instances of the same index. This is the number of
%peaks after the location-based filter
for i=1:size(data,1)
    data(i,6)=sum(data(:,7)==data(i,7));
end

%Calculate mean and std dev for ratio
SNormRat = std(data(:,10));
uNormRat = mean(data(:,10));
%Calculate mean and std dev for ratio
Srat = std(data(:,8));
uRat = mean(data(:,8));
%Prom
Sprom = std(data(:,5));
uProm = mean(data(:,5));

%%% Data Plots

%Plot Prominence Data
figure
stem(data(:,1),data(:,5))
title('Prominence Before Filter')
uPromLine = refline([0 uProm]);
uPromLine.Color = 'r';
SpromLine = refline([0 (uProm+(stdDevCoef*Sprom))]);
SpromLine.Color = 'b';
ylabel('Prominence')
xlabel(pictureLabels)
%saveas(gcf,[geometry 'PromBeforeFilter.png'])

%Plot Ratio Data
figure
stem(data(:,1),data(:,8))
title('Prominence/Width Before Filter')
uRatLine = refline([0 uRat]);
uRatLine.Color = 'r';
SratLine = refline([0 (uRat+(stdDevCoef*Srat))]);
SratLine.Color = 'b';
ylabel('Prominence/Width')
xlabel(pictureLabels)
%saveas(gcf,[geometry 'RatioBeforeFilter.png'])

%Plot Normalized Ratio Data
figure
stem(data(:,1),data(:,10))
title('Prominence/Normalized Width Before Filter')
uNormRatLine = refline([0 uNormRat]);
uNormRatLine.Color = 'r';
SNormRatLine = refline([0 (uNormRat+(stdDevCoef*SNormRat))]);
SNormRatLine.Color = 'b';
ylabel('Prominence/Normalized Width')
xlabel(pictureLabels)
%saveas(gcf,[geometry 'NormRatioBeforeFilter.png'])

%Calculate mean and std dev for ratio
% S = std(data(:,8));
% u = mean(data(:,8));
%Prom
S = std(data(:,5));
u = mean(data(:,5));

%Toss out peaks less than stdDevCoef standard devs from mean
for i=1:size(data,1)
    %Ratio
    %if(data(i,8)<((5*S)+u))
    %Prom
    if(data(i,5)<((stdDevCoef*S)+u))
        badPeaksStd=[badPeaksStd,i];
    end
end

data(badPeaksStd,:)=[];

dlmwrite(outputFilePath,data,'delimiter',',','-append');

%Plot Prominence Data
figure
stem(data(:,1),data(:,5))
ylabel('Prominence')
xlabel(pictureLabels)
%saveas(gcf,[geometry 'MaxProm.png'])

%Plot Ratio Data
figure
stem(data(:,1),data(:,8))
ylabel('Prominence/Width')
xlabel(pictureLabels)
%saveas(gcf,[geometry 'MaxRatio.png'])

%Plot Normalized Ratio Data
figure
stem(data(:,1),data(:,10))
ylabel('Prominence/Normalized Width')
xlabel(pictureLabels)
%saveas(gcf,[geometry 'MaxNormRatio.png'])


B = M.';
%save('peakVariables', 'B', 'xPos', 'runLabels');

figure
[C,h]=contourf(xPos,runLabels,B,100);
set(h,'LineColor','none')
j = colorbar;
colormap(hot)
title([geometry space expConditions 'Contour'])
axe.YTick = 1:picNum;
ylabel(pictureLabels)
xlabel('Pixel Index (x-Direction)')
%saveas(gcf,[geometry 'Contour.png'])

figure
[C,h]=contourf(xPos,runLabels,B,100);
set(h,'LineColor','none')
j = colorbar;
colormap(hot)
title([geometry space expConditions ' Peaks Superimposed on Contour'])
hold on
scatter(data(:,3),data(:,1),data(:,5)/50,'filled')
%No size differents in dots
%scatter(data(:,1),data(:,3),'filled')
axe.YTick =1:picNum;
ylabel(pictureLabels)
xlabel('Pixel Index (x-Direction)')
saveas(gcf,[geometry 'PeaksContour.png'])
hold off


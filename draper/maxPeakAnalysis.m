clear all
close all

%User-defined variables
inputFilePath = '/Users/ryansilva/Documents/Draper/Data/BaselineVs250Hc/Consolidated/resultsBaseline_3.csv';
outputFilePath = '/Users/ryansilva/Documents/Draper/Data/BaselineVs250Hc/Consolidated/PeaksBaseline3Max.csv';
geometry = 'Tf';
expConditions = '5% By Volume';
pictureLabels = 'Run Number'; %Example: Frequency (MHz)

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
runLabels = [1:picNum]; %For Run number
%runLabels = [0.5:0.01:2]; %For Freq Sweep
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

%Plot Prominence Data
figure
stem(data(:,1),data(:,5))
title('Prominence Before Filter')
uPromLine = refline([0 uProm]);
uPromLine.Color = 'r';
SpromLine = refline([0 (uProm+Sprom)]);
SpromLine.Color = 'b';
ylabel('Prominence')
xlabel(pictureLabels)
saveas(gcf,[geometry 'PromBeforeFilter.png'])

%Plot Ratio Data
figure
stem(data(:,1),data(:,8))
title('Prominence/Width Before Filter')
uRatLine = refline([0 uRat]);
uRatLine.Color = 'r';
SratLine = refline([0 (uRat+Srat)]);
SratLine.Color = 'b';
ylabel('Prominence/Width')
xlabel(pictureLabels)
saveas(gcf,[geometry 'RatioBeforeFilter.png'])

%Plot Normalized Ratio Data
figure
stem(data(:,1),data(:,10))
title('Prominence/Normalized Width Before Filter')
uNormRatLine = refline([0 uNormRat]);
uNormRatLine.Color = 'r';
SNormRatLine = refline([0 (uNormRat+SNormRat)]);
SNormRatLine.Color = 'b';
ylabel('Prominence/Normalized Width')
xlabel(pictureLabels)
saveas(gcf,[geometry 'NormRatioBeforeFilter.png'])

data(badPeaksStd,:)=[];

%Find max prominence for each picture
for i=1:size(data,1)
  equalIndex = find(data(:,7)==(i-1));
  maxProm = max(data(min(equalIndex):max(equalIndex),5));
  find(data(min(equalIndex):max(equalIndex),5) < maxProm);
  inx = find(data(min(equalIndex):max(equalIndex),5) < maxProm) + (min(equalIndex)-1);
  inx = inx';
  smallPeaksStd=[smallPeaksStd,inx];
end
data(smallPeaksStd,:)=[];

dlmwrite(outputFilePath,data,'delimiter',',','-append');

%%% Data Plots

%Plot Prominence Data
figure
stem(data(:,1),data(:,5))
%title('Maximum Prominence','FontWeight', 'bold', 'FontSize', 20)
ylabel('Prominence (Pixel Intensity)','FontWeight', 'bold', 'FontSize', 20)
xlabel(pictureLabels, 'FontWeight', 'bold', 'FontSize', 20)
set(gca,'FontSize',20)
saveas(gcf,[geometry 'MaxPromStem.png'])

%Plot Ratio Data
figure
stem(data(:,1),data(:,8))
title('Prominence/Width for Maximum Prominence')
ylabel('Prominence/Width')
xlabel(pictureLabels)
saveas(gcf,[geometry 'MaxRatio.png'])

%Plot Normalized Ratio Data
figure
stem(data(:,1),data(:,10))
title('Prominence/Normalized Width for Maximum Prominence')
ylabel('Prominence/Normalized Width')
xlabel(pictureLabels)
saveas(gcf,[geometry 'MaxNormRatio.png'])


B = M.';
save('peakVariables', 'B', 'xPos', 'runLabels');

figure
[C,h]=contourf(xPos,runLabels,B,100);
set(h,'LineColor','none')
j = colorbar;
colormap(hot)
title([geometry space expConditions 'Contour'])
axe.YTick = 1:picNum;
ylabel(pictureLabels)
xlabel('Pixel Index (x-Direction)')
saveas(gcf,[geometry 'Contour.png'])

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

figure
scatter(data(:,3),data(:,1),data(:,5)/50,'filled')
%No size differents in dots
%scatter(data(:,3),data(:,1),'filled')
axe = gca;
axe.XLim = [0 size(M,1)];
axe.YLim = [1 picNum];
axe.YTick = 1:picNum;
title([geometry space expConditions ' Peaks'])
ylabel(pictureLabels)
xlabel('Pixel Index (x-Direction)')
saveas(gcf,[geometry 'Peaks.png'])

figure
plot(xPos(size(M,1)/5:(4*size(M,1)/5)),M(size(M,1)/5:(4*size(M,1)/5),1),'c-.',xPos(size(M,1)/5:(4*size(M,1)/5)),M(size(M,1)/5:(4*size(M,1)/5),2),'--',xPos(size(M,1)/5:(4*size(M,1)/5)),M(size(M,1)/5:(4*size(M,1)/5),3),'k:',xPos(size(M,1)/5:(4*size(M,1)/5)),M(size(M,1)/5:(4*size(M,1)/5),4),'LineWidth',2)
xlabel('Normalized Position within Channel Width','FontWeight', 'bold', 'FontSize', 20)
ylabel('Pixel Intensity','FontWeight', 'bold', 'FontSize', 20)
set(gca,'FontSize',20)
axe=gca;
%title('Prominence at 25ul/min and Varying Power Levels')
legend('250mW','500mW','750mW','1000mW')
axe.XLim = [0 size(M,1)];
axe.XTick = [0 size(M,1)/4 size(M,1)/2 3*size(M,1)/4 size(M,1)];
axe.XTickLabels = ({'-0.5' '-0.25' '0' '0.25' '0.5'});
saveas(gcf,[geometry 'PromPower.png'])

figure
plot(xPos(size(M,1)/5:(4*size(M,1)/5)),M(size(M,1)/5:(4*size(M,1)/5),3),xPos(size(M,1)/5:(4*size(M,1)/5)),M(size(M,1)/5:(4*size(M,1)/5),7),'--',xPos(size(M,1)/5:(4*size(M,1)/5)),M(size(M,1)/5:(4*size(M,1)/5),11),'k:','LineWidth',2)
xlabel('Normalized Position within Channel Width', 'FontWeight', 'bold', 'FontSize', 20)
ylabel('Pixel Intensity', 'FontWeight', 'bold', 'FontSize', 20)
set(gca,'FontSize',20)
axe=gca;
%title('Prominence at 750mW and Varying Flow Rates')
legend('25\mul/min','50\mul/min','75\mul/min')
axe.XLim = [0 size(M,1)];
axe.XTick = [0 size(M,1)/4 size(M,1)/2 3*size(M,1)/4 size(M,1)];
axe.XTickLabels = ({'-0.5' '-0.25' '0' '0.25' '0.5'});
saveas(gcf,[geometry 'PromFlow.png'])

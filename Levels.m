function Levels(M,metaData)
% LEVELS Create Ber Graph from the data in the test file which seperats the error types to each level-to-level errors
% M			The Data matrix which contains all the data from the test file
% MetaData	Class instance which contains the information about the test
%
% works only for all points, for average see LEVELSAVERAGES

% if metadata is missing architecture info, assuming MLC.
if (metaData.architecture ~= -1)
    arc = metaData.architecture;
else
    arc = 0;
end

%num of levels is calculated by (2^numOfBits)^2-2^numOfBits

if (arc == architecture.tlc)
     numOfLevels = 8;
     if (size(M, 2) <  2*metaData.pagesPerBlock + 2)
         err = sprintf('Error in file format: Looks like levels data is missing in the loaded file.  (TLC architecture test loaded)');
         msgbox(err,'Error reading file');
         return;
     end
else
    %MLC
    numOfLevels = 4;
end

numOfTicks = numOfLevels^2-numOfLevels;
%bpb - bits per block
bpb = metaData.bytesPerPage*metaData.pagesPerBlock*8;
startingPoint = 2*metaData.pagesPerBlock;
figure
title('Levels');
ylabel('P/E cycle');
zlabel('BER');
set(gca,'ZScale','log')

grid on
hold on
Y = 1:size(M,1);

for i = 1:numOfTicks 
    X = ones(1,size(M,1)).*i;
    Z = sum(M(:,startingPoint+i:numOfTicks:end),2)./bpb;
    plot3(X,Y,Z);
end
set(gca,'XTick',(1:numOfLevels-1:numOfTicks));
set(gca,'XMinorTick','off');
set(gca,'XLim',[1 numOfTicks]);

leggendLables = generateLevelsLeggendLables(numOfLevels);
Xticks = leggendLables(1:numOfLevels-1:end,1:end);
set(gca,'XTickLabel', Xticks);
view(45,10);

legend(leggendLables);
hold off
end
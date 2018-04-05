function LevelsAverages(M,metaData,headiterations, headGroupSize, middleIterations, middleGroupSize,tailGroupSize)
% LEVELSAVERAGES Create Ber Graph from the data in the test file which seperats the error types to each level-to-level errors with average values which were set by the user
% M					The Data matrix which contains all the data from the test file
% MetaData			Class instance which contains the information about the test
% headIterations	The number of iteration which includes in the "Head" group
% headGroupSize		Number of interations which we should "group" together to one point in the "Head" section
% middleIterations	The number of iteration which includes in the "Middle" group
% middleGroupSize	Number of interations which we should "group" together to one point in the "Middle" section
% tailGroupSize		Number of interations which we should "group" together to one point in the "Tail" section

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

for i = 1:numOfTicks
    Z = sum(M(:,startingPoint+i:numOfTicks:end),2)./bpb;
    [Y,Z] = averageVector(Z',headiterations, headGroupSize, middleIterations, middleGroupSize,tailGroupSize);
    X = ones(1,size(Y,2)).*i;
    plot3(X,Y,Z);

end
set(gca,'XTick',(1:numOfLevels-1:numOfTicks));
set(gca,'XMinorTick','off');
set(gca,'XLim',[1 numOfTicks]);

leggendLables = generateLevelsLeggendLables(numOfLevels);
Xticks = leggendLables(1:numOfLevels-1:end,1:end);
set(gca,'XTickLabel', Xticks);
view(45,10);
%MLC legend
legend(leggendLables);
hold off
end
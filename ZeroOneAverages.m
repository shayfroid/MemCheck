function ZeroOneAverages(M,metaData,headiterations, headGroupSize, middleIterations, middleGroupSize,tailGroupSize)
% ZEROONEAVERAGES Create Ber Graph from the data in the test file which seperats the error types to 1->0 and 0->1 errors with average values which were set by the user
% M					The Data matrix which contains all the data from the test file
% MetaData			The array which contains the information about the test
% headIterations	The number of iteration which includes in the "Head" group
% headGroupSize		Number of interations which we should "group" together to one point in the "Head" section
% middleIterations	The number of iteration which includes in the "Middle" group
% middleGroupSize	Number of interations which we should "group" together to one point in the "Middle" section
% tailGroupSize		Number of interations which we should "group" together to one point in the "Tail" section

bpb = metaData.bytesPerPage*metaData.pagesPerBlock*8;

% reading the data to matrix to create graph
%M = dlmread(filename,'\t',2,1);
M_01 = sum(M(:,1:2:(2*metaData.pagesPerBlock-1)),2)./bpb;
[X_01,M_01] = averageVector(M_01',headiterations, headGroupSize, middleIterations, middleGroupSize,tailGroupSize);
M_10 = sum(M(:,2:2:(2*metaData.pagesPerBlock)),2)./bpb;
[X_10,M_10] = averageVector(M_10',headiterations, headGroupSize, middleIterations, middleGroupSize,tailGroupSize);

% creating the BER graph
figure
semilogy(X_01,M_01,X_10,M_10);
title('0->1 & 1->0');
xlabel('P/E cycle');
ylabel('BER');
s = {'0->1','1->0'};
legend(s,'Location','northwest');
grid on
grid minor
end
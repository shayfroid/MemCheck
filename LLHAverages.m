function LLHAverages(M,metaData,headIterations,headGroupSize,middleIterations, middleGroupSize,tailGroupSize)
% BERAverages Create Ber Graph from the data in the test file with average values which were set by the user
% M					The Data matrix which contains all the data from the test file
% MetaData			Class instance which contains the information about the test
% headIterations	The number of iteration which includes in the "Head" group
% headGroupSize		Number of interations which we should "group" together to one point in the "Head" section
% middleIterations	The number of iteration which includes in the "Middle" group
% middleGroupSize	Number of interations which we should "group" together to one point in the "Middle" section
% tailGroupSize		Number of interations which we should "group" together to one point in the "Tail" section

bpb = metaData.pagesPerBlock*metaData.bytesPerPage*8;
LLH = sum(M(:,1:end),2)./bpb;

[X,Y] = averageVector(LLH',headIterations,headGroupSize,middleIterations, middleGroupSize,tailGroupSize);

% creating the BERAverages graph
figure
semilogy(X,Y);
title('L-LH');
xlabel('P/E cycle');
ylabel('BER');
legend('BER','Location','northwest');
grid on
grid minor
end
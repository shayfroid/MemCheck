function BERAverages(M,metaData,headIterations,headGroupSize,middleIterations, middleGroupSize,tailGroupSize)
% BERAverages Create Ber Graph from the data in the test file with average values which were set by the user
% M					The Data matrix which contains all the data from the test file
% MetaData			Class instance which contains the information about the test
% headIterations	The number of iteration which includes in the "Head" group
% headGroupSize		Number of interations which we should "group" together to one point in the "Head" section
% middleIterations	The number of iteration which includes in the "Middle" group
% middleGroupSize	Number of interations which we should "group" together to one point in the "Middle" section
% tailGroupSize		Number of interations which we should "group" together to one point in the "Tail" section

% bpb - bits per block (bpb). the number of pages
% in a block * number of bytes in  single page * 8 = number of bits per
% block
bpb = metaData.pagesPerBlock*metaData.bytesPerPage*8;
BER = sum(M(:,1:(2*metaData.pagesPerBlock)),2)./bpb;

[X,Y] = averageVector(BER',headIterations,headGroupSize,middleIterations, middleGroupSize,tailGroupSize);

% creating the BERAverages graph
figure
semilogy(X,Y);
title('BER');
xlabel('P/E cycle');
ylabel('BER');
legend('BER','Location','northwest');
grid on
grid minor
end
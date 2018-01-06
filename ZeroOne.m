function ZeroOne(M,metaData)
% ZEROONE Create Ber Graph from the data in the test file which seperats the error types to 1->0 and 0->1 errors
% M			The Data matrix which contains all the data from the test file
% MetaData	Class Instance which contains the information about the test
%
% works only for all points, for average see ZEROONEAVERAGES

bpb = metaData.bytesPerPage*metaData.pagesPerBlock*8;

% reading the data to matrix to create graph
%M = dlmread(filename,'\t',2,1);
M_01 = sum(M(:,1:2:(2*metaData.pagesPerBlock-1)),2)./bpb;
M_10 = sum(M(:,2:2:(2*metaData.pagesPerBlock)),2)./bpb;
X = 1:size(M,1);
% creating the BER graph

figure
%semilogy(X,M_01,X,M_10);
semilogy(X,M_01,X,M_10);
title('0->1 & 1->0');
xlabel('P/E cycle');
ylabel('BER');
s = {'0->1','1->0'};
legend(s,'Location','northwest');
grid on
grid minor
end
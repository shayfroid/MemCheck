function BER(M,metaData)
% BER Create Ber Graph from the data in the test file
% M			The Data matrix which contains all the data from the test file
% MetaData	Class instance which contains the information about the test
%
% works only for all points, for average see BERAVERAGES

% bpb- bits per block (bpb). the number of pages
% in a block * number of bytes in  single page * 8 = number of bits per
% block
bpb = metaData.bytesPerPage*metaData.pagesPerBlock*8;
BER = sum(M(:,1:(2*metaData.pagesPerBlock)),2)./bpb;

% creating the BER graph
figure
semilogy(BER);
title('BER');
xlabel('P/E cycle');
ylabel('BER');
legend('BER','Location','northwest');
grid on
grid minor
end
function LLH(M_,M2_,graphnames,multipleGraphs,metaData)
% BER Create Ber Graph from the data in the test file
% M			The Data matrix which contains all the data from the test file
% MetaData	Class instance which contains the information about the test
%
% works only for all points, for average see BERAVERAGES

bpb = metaData.bytesPerPage*metaData.pagesPerBlock*8;
figure
set(gca,'YScale','log')
title('L-LH');
xlabel('P/E cycle');
ylabel('BER');

grid on
grid minor
hold on

if(isempty(M2_))
    title('Full L-LH');
    for i = 1:size(M_,2)
        M2_{i} = [];
        graphnames{i} = 'Full LLH'; 
    end
end
if(~multipleGraphs)
    M = zeros(size(M_{1}));
    M2 = zeros(size(M2_{1}));
    for i = 1:size(M_,2)
        M = M + M_{i};
        M2 = M2 + M2_{i};
    end
    M = [M;M2];
    LLH = sum(M(:,1:end),2)./(bpb*size(M_,2));
    
    % creating the BER graph
    plot(LLH);


else
    
    for i = 1:size(M_,2)
        M = [M_{i};M2_{i}];
        LLH = sum(M(:,1:end),2)./bpb;
        plot(LLH);
    end
    hold off
end
if(multipleGraphs)
    legend(graphnames,'Location','southeast');
else
    legend('BER','Location','southeast');
end;
hold off  



% creating the BER graph

%end
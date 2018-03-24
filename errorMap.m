function errorMap(M,metaData,min,max,combine,markers,markers_size)
% ERRORMAP Builds the error-map graph 
arc_strings = {'MLC','TLC'};

filterString = '';
if min > 0
    M(M < min) = nan;
    filterString = sprintf(', %d <= Error',min);
end
if max  > 0
    M(M > max) = nan;
    if(isempty(filterString))
        filterString = sprintf(', Error <= %d',max);
    else
        filterString = strcat(filterString, sprintf(' < %d',max));
    end
    
end
if(combine ~= 1)
    figure
    h = stem3(M(:,1:size(M,2)/2),'marker','.', 'markersize',markers_size);
    if(markers == 0)
        set(h,'marker','none');
    end
    title(sprintf('Bit Error Map - left (%s)%s',arc_strings{metaData.architecture + 1}, filterString));
    if metaData.architecture == architecture.mlc
        ylabel('Pair');
    else
        ylabel('Triplet');
    end
    zlabel('Errors');
    xlabel('Cell');
    set(gca,'YLim',[0 size(M,1)]);
    %set(gca,'XLim',[0 metaData(4)*8]);
    grid on

    figure
    h = stem3(M(:,(size(M,2)/2)+1:end),'marker','.', 'markersize',markers_size);
    if(markers == 0)
        set(h,'marker','none');
    end
    title(sprintf('Bit Error Map - right (%s)%s',arc_strings{metaData.architecture + 1},filterString));
    if metaData.architecture == architecture.mlc
        ylabel('Pair');
    else
        ylabel('Triplet');
    end
    zlabel('Errors');
    xlabel('Cell');
    set(gca,'YLim',[0 size(M,1)]);
    %set(gca,'XLim',[0 metaData(4)*8]);
    set(h,'Color','r');
    grid on
else
    left = NaN(size(M));
    left(:,1:2:end) = M(:,1:size(M,2)/2);
    right = NaN(size(M));
    right(:,2:2:end) = M(:,(size(M,2)/2)+1:end);
    
    figure
    h = stem3(left,'marker','.', 'markersize',markers_size);
    if(markers == 0)
        set(h,'marker','none');
    end
    set(h,'Color','b');
    hold on
    h = stem3(right,'marker','.', 'markersize',markers_size);
    if(markers == 0)
        set(h,'marker','none');
    end
    set(h,'Color','r');
    hold off
    title(sprintf('Bit Error Map - left & right (%s)%s',arc_strings{metaData.architecture + 1},filterString));
    if metaData.architecture == architecture.mlc
        ylabel('Row');
    else
        ylabel('Word Line');
    end
    zlabel('Errors');
    xlabel('Cell');
    %set(gca,'XLim',[0 metaData(4)*8]);
    set(gca,'YLim',[0 size(M,1)]);
end
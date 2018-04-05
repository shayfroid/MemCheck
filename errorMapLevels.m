function errorMapLevels(M,metaData,min,max,combine,markers,markers_size, filepath, pair_planes)
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


pages_order = pagesOrder(filepath);
ppb = metaData.pagesPerBlock;

if metaData.architecture == architecture.mlc
   % M will be in the following structure:
   %   __________________________
   %  |left low    |  right low  |
   %  |--------------------------|
   %  |left high   |  right high |
   %  |--------------------------|
   
   left_low_pages = pages_order(1:2:ppb/2);
   right_low_pages = pages_order(2:2:ppb/2);
   left_high_pages = pages_order(ppb/2+1:2:end);
   right_high_pages = pages_order(ppb/2+2:2:end);
   
   left_low = M(1:size(M,1)/2,1:size(M,2)/2);
   right_low = M(1:size(M,1)/2,(size(M,2)/2)+1:end);
   left_high = M((size(M,1)/2)+1:end,1:size(M,2)/2);
   right_high = M((size(M,1)/2)+1:end,(size(M,2)/2)+1:end);
else
   % tlc, M will be in the following structure:
   %   __________________________
   %  |left low    |  right low  |
   %  |--------------------------|
   %  |left mid    |  right mid  |
   %  |--------------------------|
   %  |left high   |  right high |
   %  |--------------------------|
   
   left_low_pages = pages_order(1:2:ppb/3);
   right_low_pages = pages_order(2:2:ppb/3);
   left_mid_pages = pages_order(ppb/3+1:2:2*ppb/3);
   right_mid_pages = pages_order(ppb/3+2:2:2*ppb/3);
   left_high_pages = pages_order(2*ppb/3+1:2:end);
   right_high_pages = pages_order(2*ppb/3+2:2:end);
   
   
   left_low = M(1:size(M,1)/3,1:size(M,2)/2);
   right_low = M(1:size(M,1)/3,(size(M,2)/2)+1:end);
   left_mid = M((size(M,1)/3)+1:2*(size(M,1)/3),1:size(M,2)/2);
   right_mid = M((size(M,1)/3)+1:2*(size(M,1)/3),(size(M,2)/2)+1:end);
   left_high = M(2*(size(M,1)/3)+1:end,1:size(M,2)/2);
   right_high = M(2*(size(M,1)/3)+1:end,(size(M,2)/2)+1:end);

end

%if(combine ~= 1)
%################### Low Pages ##################################
%{
left = NaN(size(left_low,1),2*size(left_low,2));
left(:,1:2:end) = left_low;
right = NaN(size(right_low,1),2*size(right_low,2));
right(:,2:2:end) = right_low;
%}
    %left = M(:,1:size(M,2)/2);
    %right = M(:,(size(M,2)/2)+1:end);
figure
l_l = stem3(0:(size(M,2)/2)-1, left_low_pages, left_low,'marker','.', 'markersize',markers_size);
if(markers == 0)
    set(l_l,'marker','none');
end
set(l_l,'Color','b');
hold on
if (pair_planes)
    l_r = stem3((0:(size(M,2)/2)-1)+0.1, left_low_pages, right_low, 'marker', '.', 'markersize',markers_size);
else
    l_r = stem3((0:(size(M,2)/2)-1)+0.1, right_low_pages, right_low, 'marker', '.', 'markersize',markers_size);
end
if(markers == 0)
    set(l_r,'marker','none');
end
set(l_r,'Color','g');
hold off
title(sprintf('Bit Error Map - Low pages - left & right (%s)%s',arc_strings{metaData.architecture + 1},filterString));
ylabel('Page');
zlabel('Errors');
xlabel('Cell');
set(gca,'YLim',[0 ppb]);
set(gca,'XLim',[0 metaData.bytesPerPage*8-0.8]);
legend([l_l l_r], 'Low left','Low right', 'Location','northwest');

%################### Mid Pages ##################################
if metaData.architecture == architecture.tlc
   %{
    left = NaN(size(left_mid,1),2*size(left_mid,2));
    left(:,1:2:end) = left_mid;
    right = NaN(size(right_mid,1),2*size(right_mid,2));
    right(:,2:2:end) = right_mid;
    %}
    
    figure
    m_l = stem3(0:(size(M,2)/2)-1, left_mid_pages, left_mid,'marker','.', 'markersize',markers_size);
    if(markers == 0)
        set(m_l,'marker','none');
    end
    % color- brown
    set(m_l,'Color',[208 151 53]./255);
    hold on
    if(pair_planes)
        m_r = stem3((0:(size(M,2)/2)-1)+0.1, left_mid_pages, right_mid,'marker','.', 'markersize',markers_size);
    else
        m_r = stem3((0:(size(M,2)/2)-1)+0.1, right_mid_pages, right_mid,'marker','.', 'markersize',markers_size);
    end
    if(markers == 0)
        set(m_r,'marker','none');
    end
    % color- light gray
    set(m_r,'Color',[0.7 0.7 0.7]);
    hold off
    title(sprintf('Bit Error Map - middle pages - left & right (%s)%s',arc_strings{metaData.architecture + 1},filterString));
    ylabel('Page');
    zlabel('Errors');
    xlabel('Cell');
    set(gca,'YLim',[0 ppb]);
    set(gca,'XLim',[0 metaData.bytesPerPage*8-0.8]);
    legend([m_l m_r], 'Middle left','Middle right', 'Location','northwest');
end    
%################### High Pages ##################################
%{
left = NaN(size(left_high,1),2*size(left_high,2));
left(:,1:2:end) = left_high;
right = NaN(size(right_high,1),2*size(right_high,2));
right(:,2:2:end) = right_high;
%}
figure
h_l = stem3(0:(size(M,2)/2)-1, left_high_pages, left_high,'marker','.', 'markersize',markers_size);
if(markers == 0)
    set(h_l,'marker','none');
end
set(h_l,'Color','r');
hold on
if(pair_planes)
    h_r = stem3((0:(size(M,2)/2)-1)+0.1, left_high_pages, right_high,'marker','.', 'markersize',markers_size);
else
    h_r = stem3((0:(size(M,2)/2)-1)+0.1, right_high_pages, right_high,'marker','.', 'markersize',markers_size);
end
if(markers == 0)
    set(h_r,'marker','none');
end
% color- Black
set(h_r,'Color',[0 0 0]./255);
hold off
title(sprintf('Bit Error Map - high pages - left & right (%s)%s',arc_strings{metaData.architecture + 1},filterString));
ylabel('Page');
zlabel('Errors');
xlabel('Cell');
set(gca,'YLim',[0 ppb]);
set(gca,'XLim',[0 metaData.bytesPerPage*8-0.8]);
legend([h_l h_r], 'High left','High right', 'Location','northwest');

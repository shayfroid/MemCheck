function  BerPerPage(M,metaData,pagesString,filepath,compactGraph)
% BERPERPAGE Create Ber Graph for each page in the device from the data in the test file
% M				The Data matrix which contains all the data from the test file
% MetaData		Class instance which contains the information about the test
% pagesString	A string which represent an array of pages the user want to see instead of all the pages
% filepath		Path to the data file (or the first data file in case of muliple files)
% compactGraph	Flag which tells the function if to devide each row to 2 separate tuples or not
%
% works only for all points, for average see BERPERPAGEAVERAGES

if (metaData.architecture ~= architecture.mlc && metaData.architecture ~= architecture.tlc)
    msgID = 'MYFUN:Bad_architecture';
    throw(MException(msgID,'Unsupported architecture for BerPErPage'));
end

po = pagesOrder(filepath);
if(isempty(pagesString))
    pages = (0:(metaData.pagesPerBlock-1));
elseif (strcmpi(pagesString,'low'))
    if metaData.architecture == architecture.mlc
        pages = po(1:(metaData.pagesPerBlock/2));
    else  %metaData.architecture == architecture.tlc
        pages = po(1:3:end);
    end
elseif (strcmpi(pagesString, 'middle'))
    if metaData.architecture == architecture.tlc
        pages = po(2:3:end);
    else
        throw(MException('MYFUN:Bad_filter', '"middle" filter is only meaningful with TLC architecture'));
    end
elseif (strcmpi(pagesString,'high'))
    if metaData.architecture == architecture.mlc
        pages = po(1+(metaData.pagesPerBlock/2):metaData.pagesPerBlock);
    else
        pages = po(3:3:end);
    end
else
    pages = str2num(pagesString);
end

if(isempty(pages))
    msgbox('Ivalid "Pages to show" String. Could not parse the pages filter');
    return;
end
figure
title('Ber Per  Page');
ylabel('P/E cycle');
zlabel('BER');
xlabel('Page');
set(gca,'ZScale','log')

grid on
hold on

Y = 1:size(M,1);
onceLow = false;
onceHigh = false;
onceMid = false;

for i = 0:(metaData.pagesPerBlock-1) 
    if (any(pages == i))
        [~,indexOfI] = ismember(i,po);
        X = ones(1,size(M,1)).*i;
        Z = (M(:,2*indexOfI)+M(:,(2*indexOfI)-1))./(metaData.bytesPerPage*8);
        h = plot3(X,Y,Z);
        if (metaData.architecture == architecture.mlc && (indexOfI > (metaData.pagesPerBlock/2))) || ... 
            (metaData.architecture == architecture.tlc && (mod(indexOfI-1,3) == 2))
            set(h,'Color','r');
            if(~onceHigh)
                hH = h;
                onceHigh = true;
            end
        elseif metaData.architecture == architecture.mlc || ...
                (mod(indexOfI-1,3) == 0)
            set(h,'Color','b');
            if(~onceLow)
                hL = h;
                onceLow = true;
            end
        else
            % TLC architecture and "middle" page
            set(h,'Color','g');
            if(~onceMid)
                hM = h;
                onceMid = true;
            end
        end
    end
end
if(compactGraph{1} == 1)
    set(gca,'XLim',[0 max(1,max(pages))]);
else
    set(gca,'XLim',[0 (metaData.pagesPerBlock-1)]);
end
view(45,10);
if(onceLow && onceHigh && onceMid)
    legend([hL hM hH],'Low Pages','Middle pages', 'High Pages','Location','northwest');
elseif (onceLow && onceMid)
    legend([hL hM], 'Low Pages','Middle pages', 'Location','northwest');
elseif (onceLow && onceHigh)
    legend([hL hH],'Low Pages', 'High Pages','Location','northwest');
elseif (onceMid && onceHigh)
    legend([hM hH],'Middle pages', 'High Pages','Location','northwest');
elseif onceHigh
    legend('High Pages','Location','northwest');
elseif onceMid
    legend('Middle Pages','Location','northwest');
else
    legend('Low Pages','Location','northwest');
end
hold off

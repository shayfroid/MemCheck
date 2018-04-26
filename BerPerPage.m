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
    msgbox('Unsupported architecture for BerPErPage');
    return;
end

po = pagesOrder(filepath);
ppb = metaData.pagesPerBlock;

if metaData.architecture == architecture.mlc
    low_pages = po(1:ppb/2);

    high_pages = po(1+(ppb/2):end);
else
    low_pages = po(1:ppb/3);
    middle_pages = po(ppb/3+1:2*(ppb/3));
    high_pages = po(2*(ppb/3)+1:end);
end

if(isempty(pagesString))
    pages = (0:(ppb-1));
elseif (strcmpi(pagesString,'low'))
    pages = low_pages;
elseif (strcmpi(pagesString, 'middle'))
    if metaData.architecture == architecture.tlc
        pages = middle_pages;
    else
        msgbox('"middle" filter is only meaningful for TLC architecture');
        return;
    end
elseif (strcmpi(pagesString,'high'))
    pages = high_pages;
else
    pages = str2num(pagesString);
    pages = pages(pages < ppb);
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
        if (any(high_pages == i))
            set(h,'Color','r');
            if(~onceHigh)
                hH = h;
                onceHigh = true;
            end
        elseif (any(low_pages == i))
            set(h,'Color','b');
            if(~onceLow)
                hL = h;
                onceLow = true;
            end
        else
            % "middle" page
            set(h,'Color','g');
            if(~onceMid)
                hM = h;
                onceMid = true;
            end
        end
    end
end
if(compactGraph{1} == 1)
    set(gca,'XLim',[min(max(1,max(pages)), min(pages)) max(1,max(pages))]);
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

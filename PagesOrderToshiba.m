function [lp, mp, up ] = PagesOrderToshiba(chipArchitecture, numOfPages)
%PAGESORDERTOSHIBA Return 3 vectors representing the pages under each plane.
%    
% Currently only supports TLC architecture of Toshiba chips.

if chipArchitecture == architecture.tlc
    %pool = 0:numOfPages-1;
    lp = 0:3:numOfPages-1;
    mp = 1:3:numOfPages-1;
    up = 2:3:numOfPages-1;
else
   err = sprintf('Only TLC architecture is corrently supported for Toshiba chips');
   msgbox(err,'Unsuported chip architecture');
   return;
end
assert(up(1,end) == numOfPages-1)
end


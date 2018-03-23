function pages_order = pagesOrderHynix(chipArchitecture,numOfPages)
if chipArchitecture == architecture.mlc
        x = 0:numOfPages-1;
        right = [x(5:4:end);x(6:4:end)];
        right = reshape(right,1,[]);
        right = [right,x(end-1:end)];
        left = setdiff(x,right);
        left = [left(1:2:end);left(2:2:end)];
        left = reshape(left,1,[]);
        
        pages_order = [left,right]
else
        err = sprintf('This chip architecture is not supported yet: %s',chipArchitecture);
        msgbox(err,'Unsuported chip architecture');      
end

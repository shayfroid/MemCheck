function [lsb,msb] = pagesOrderHynix(chipArchitecture,numOfPages)
if chipArchitecture == architecture.mlc
        x = 0:numOfPages-1;
        lsb = [x(5:4:end);x(6:4:end)];
        lsb = reshape(lsb,1,[]);
        lsb = [lsb,x(end-1:end)];
        msb = setdiff(x,lsb);
        msb = [msb(1:2:end);msb(2:2:end)];
        msb = reshape(msb,1,[]);
        
else
        err = sprintf('This chip architecture is not supported yet: %s',chipArchitecture);
        msgbox(err,'Unsuported chip architecture');      
end

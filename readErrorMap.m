function error_map = readErrorMap(filepath,numOfLines)
% error_map = READERRORMAP(s) Read the error map test file and return the map as a matrix
% The function go through the file, check it's consistency and start to parse the data
% The function then saves everything in 'error_map' and returns it.
% s		The file to read

%lines = countLines(s);
fid = fopen(filepath);
meta = metaData(str2num(fgets(fid)));
% skip the "pages order" line
fgets(fid);

if(meta.testID ~= testID.errorMap)
     err = sprintf('Incompatible file parser.\n trying to use readErrorMAp file parser while metaData specifies test ID of %d',...
            meta.testID);
        msgbox(err,'Error in test ID of wrong file parser');
else
    wb = waitbar(0,sprintf('Reading Error Map: %d%%',0)); 
    m = zeros(meta.pagesPerBlock,meta.bytesPerPage*8);
    iter = 0;
    while ~feof(fid)
       arr =  str2num(fgets(fid));
       i = 2;
       while i < length(arr)
          page = arr(i);
          i = i+1;
          if arr(i) ~= 0
            bits = arr(i+1:i+arr(i));
          else
              bits = [];
          end
          i = i+arr(i)+1;
          if arr(i) ~= 0
            bits = [bits,arr(i+1:i+arr(i))];
          end
          i = i+arr(i)+1;
          m(page+1,bits+1) = m(page+1,bits+1)+1;      
       end
       iter = iter + 1;
       waitbar(double(iter/numOfLines),wb,sprintf('Reading Error Map: P/E Cycle %d/%d',iter,numOfLines));
    end
    close(wb);
    delete(wb);
end
fclose(fid);
pages_order = pagesOrder(filepath);
ppb = meta.pagesPerBlock;

% calculate pages order
if ( meta.architecture == architecture.mlc)
    % Heynix manufacturer
    %[left_pages,right_pages] = pagesOrderHynix(meta.architecture,meta.pagesPerBlock);
    left_pages = pages_order(1:ppb/2);
    right_pages = pages_order((ppb/2) + 1:end);
    
    sums = zeros(ppb/2,meta.bytesPerPage*8);
    for i = 1:meta.pagesPerBlock/2
        %asuming an error in both pages is not possible. 
        sums(i,:) = m(right_pages(i)+1,:)+m(left_pages(i)+1,:);
    end
    left = sums(1:2:end,:);
    right = sums(2:2:end,:);
    
elseif (meta.architecture == architecture.tlc)
    sums = zeros(ppb/3, meta.bytesPerPage*8);
    triplets = [pages_order(1:ppb/3);
                pages_order(ppb/3+1:2*(ppb/3));
                pages_order(2*(ppb/3)+1:end)];

    for triplet = 1:ppb/3
        sums(triplet,:) = sum(m(triplets(:,triplet)+1,:));
    end
    left = sums(1:2:ppb/3,:);
    right = sums(2:2:ppb/3,:);
    
else
    err = sprintf('Unsupported architecture for BitErrorMap.');
    msgbox(err,'Unsupported manufacturer'); 
    return;
end

error_map = [left,right];
%disp ('writing sum');
%dlmwrite('F:\\test2.sum',error_map);




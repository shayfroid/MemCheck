function error_map = readErrorMap(filepath,numOfLines)
% error_map = READERRORMAP(s) Read the error map test file and return the map as a matrix
% The function go through the file, check it's consistency and start to parse the data
% The function then saves everything in 'error_map' and returns it.
% s		The file to read

%lines = countLines(s);
fid = fopen(filepath);
meta = metaData(str2num(fgets(fid)));


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

% calculate pages order
if (meta.manufacturer == manufecturers.hynix && meta.architecture == architecture.mlc)
    % Heynix manufacturer
    [left_pages,right_pages] = pagesOrderHynix(meta.architecture,meta.pagesPerBlock);
elseif (meta.manufacturer == manufecturers.toshiba && meta.architecture == architecture.tlc)
    % for TLC not using external function to calculate pages order since
    %                      _________
    % its straight fwd... | 0 | 258 | etc...
    %                     |---------|
    %             WL 0    | 1 | 259 |
    %                     |---------|
    %                     | 2 | 260 |
    %                      ---------
    %                     left | right
    
    %[l_plane, m_plane, u_plane] = PagesOrderToshiba(meta.architecture, meta.pagesPerBlock);
else
    err = sprintf('Unsupported manufacturer or architecture for BitErrorMap: In order to rander Bit Error Map graph the pages order and the coupling must be known. At the moment the the data is known for Hynix with MLC architecture or Toshiba with TLC architecture only.');
    msgbox(err,'Unsupported manufacturer or architecture'); 
    return;
end

if (meta.manufacturer == manufecturers.hynix && meta.architecture == architecture.mlc)
    sums = zeros(meta.pagesPerBlock/2,meta.bytesPerPage*8);
    for i = 1:meta.pagesPerBlock/2
        %asuming an error in both pages is not possible. 
        sums(i,:) = m(right_pages(i)+1,:)+m(left_pages(i)+1,:);
    end
    left = sums(1:2:end,:);
    right = sums(2:2:end,:);

elseif (meta.manufacturer == manufecturers.toshiba && meta.architecture == architecture.tlc)
    sums = zeros(meta.pagesPerBlock/3, meta.bytesPerPage*8);
    triplet = 1;
    for i = 1:3:meta.pagesPerBlock
        sums(triplet,:) = sum(m(i:i+2,:));
        triplet = triplet+1;
    end
    left = sums(1:meta.pagesPerBlock/6,:);
    right = sums(meta.pagesPerBlock/6 + 1:end, :);
else
    % unsupporteed combination of manufacturere and architecture.
    error_map = zeros(1,1);
    return;
           
end
error_map = [left,right];
%disp ('writing sum');
%dlmwrite('F:\\test2.sum',error_map);




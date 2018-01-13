function error_map = readErrorMapCalibrated(filepath,numOfLines)
% error_map = READERRORMAP(s) Read the error map test file and return the map as a matrix
% The function go through the file, check it's consistency and start to parse the data
% The function then saves everything in 'error_map' and returns it.
% s		The file to read

fid = fopen(filepath);
meta = metaData(str2num(fgets(fid)));


if(meta.testID ~= testID.errorMap)
     err = sprintf('Incompatible file parser.\n trying to use readErrorMAp file parser while metaData specifies test ID of %d',...
            meta.testID);
        msgbox(err,'Error in test ID of wrong file parser');
        error_map = zeros(1,1);
        return;
end

wb = waitbar(0,sprintf('Reading Error Map: %d%%',0)); 
m = zeros(meta.pagesPerBlock,meta.bytesPerPage*8);

if (meta.architecture == architecture.mlc)
    summed_errors = zeros(meta.pagesPerBlock/2,meta.bytesPerPage*8);
    %tmp_sums = zeros(meta.pagesPerBlock/2,meta.bytesPerPage*8);
    pages_order = pagesOrderHynix(meta.architecture,meta.pagesPerBlock);
    pages_coupling = reshape(pages_order,meta.pagesPerBlock/2,2);
elseif (meta.architecture == architecture.tlc)
    summed_errors = zeros(meta.pagesPerBlock/3,meta.bytesPerPage*8);
    %tmp_sums = zeros(meta.pagesPerBlock/3,meta.bytesPerPage*8);
    pages_order = [0:3:515,1:3:515,2:3:515];
    pages_coupling = reshape(pages_order,meta.pagesPerBlock/3,3);
end

iter = 0;
while ~feof(fid)
    m = zeros(meta.pagesPerBlock,meta.bytesPerPage*8);
    arr =  str2num(fgets(fid));
    i = 2;
    length = length(arr);
    while i < length
        page = arr(i);
        i = i+1;
        bits = arr(i+1:i+arr(i));
        i = i+arr(i)+1;
        bits = [bits,arr(i+1:i+arr(i))];
        i = i+arr(i)+1;
        m(page+1,bits+1) = 1;      
    end
    
    summed_errors_per_loop = zeros(size(summed_errors));
    for i = 1:size(pages_coupling,1)
       summed_errors_per_loop(i,:) = sum(m(pages_coupling(i,:)+1,:));
    end
    summed_errors_per_loop(summed_errors_per_loop > 1) = 1;
    summed_errors = summed_errors + summed_errors_per_loop;
    %{
    if (meta.architecture == architecture.mlc)
        for i = 1:meta.pagesPerBlock/2
            tmp_sums(i,:) = sum(m(pages_coupling(i,:),:));
            %tmp_sums(i,:) = m(right_pages(i)+1,:)+m(left_pages(i)+1,:);
        end
        sums = sums + tmp_sums;

    elseif (meta.architecture == architecture.tlc)
        triplet = 1;
        for i = 1:3:meta.pagesPerBlock
            tmp_sums(triplet,:) = sum(m(i:i+2,:));
            triplet = triplet+1;
        end
        %{
        for i = 1:3:meta.pagesPerBlock/3
            temp_sums(i,:) = sum(m(i:i+2,:));
        end
        %}
    else
    % unsupporteed combination of manufacturere and architecture.
        error_map = zeros(1,1);
        return;        
    end
    %}
    
    
    
    iter = iter + 1;
    waitbar(double(iter/numOfLines),wb,sprintf('Reading Error Map: P/E Cycle %d/%d',iter,numOfLines));
end
close(wb);
delete(wb);

fclose(fid);

if (meta.architecture == architecture.mlc)
    summed_errors = zeros(meta.pagesPerBlock/2,meta.bytesPerPage*8);
    for i = 1:meta.pagesPerBlock/2
        %asuming an error in both pages is not possible. 
        summed_errors(i,:) = m(right_pages(i)+1,:)+m(left_pages(i)+1,:);
    end
    left = summed_errors(1:2:end,:);
    right = summed_errors(2:2:end,:);

elseif (meta.architecture == architecture.tlc)
    summed_errors = zeros(meta.pagesPerBlock/3, meta.bytesPerPage*8);
    for i = 1:3:meta.pagesPerBlock/3 
        summed_errors(i,:) = sum(m(i:i+2,:));
    end
    left = summed_errors(1:meta.pagesPerBlock/6,:);
    right = summed_errors(meta.pagesPerBlock/6 + 1:end, :);
else
    % unsupporteed combination of manufacturere and architecture.
    error_map = zeros(1,1);
    return;        
end
error_map = [left,right];
%disp ('writing sum');
%dlmwrite('F:\\test2.sum',error_map);




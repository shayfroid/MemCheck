function error_map = readErrorMapCalibrated(filepath,numOfLines, graph_type)
% error_map = READERRORMAP(s) Read the error map test file and return the map as a matrix
% The function go through the file, check it's consistency and start to parse the data
% The function then saves everything in 'error_map' and returns it.
% s		The file to read

fid = fopen(filepath);
meta = metaData(str2num(fgets(fid)));
% skip the "pages order" line
fgets(fid);

if(meta.testID ~= testID.errorMap)
     err = sprintf('Incompatible file parser.\n trying to use readErrorMAp file parser while metaData specifies test ID of %d',...
            meta.testID);
        msgbox(err,'Error in test ID of wrong file parser');
        error_map = zeros(1,1);
        return;
end

wb = waitbar(0,sprintf('Reading Error Map: %d%%',0)); 
m = zeros(meta.pagesPerBlock,meta.bytesPerPage*8);
pages_order = pagesOrder(filepath);
ppb = meta.pagesPerBlock;

if (meta.architecture == architecture.mlc)
    summed_errors = zeros(meta.pagesPerBlock/2,meta.bytesPerPage*8);
    pages_coupling = [pages_order(1:ppb/2);pages_order((ppb/2) + 1:end)]';

elseif (meta.architecture == architecture.tlc)
    summed_errors = zeros(meta.pagesPerBlock/3,meta.bytesPerPage*8);
    pages_coupling = [pages_order(1:ppb/3);
                        pages_order(ppb/3+1:2*(ppb/3));
                        pages_order(2*(ppb/3)+1:end)]';
    
end

iter = 0;
while ~feof(fid)
    m = zeros(meta.pagesPerBlock,meta.bytesPerPage*8);
    arr =  str2num(fgets(fid));
    i = 2;
    len = length(arr);
    while i < len
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
    iter = iter + 1;
    waitbar(double(iter/numOfLines),wb,sprintf('Reading Error Map: P/E Cycle %d/%d',iter,numOfLines));
end
close(wb);
delete(wb);
fclose(fid);


left = summed_errors(1:2:end,:);
right = summed_errors(2:2:end,:);
error_map = [left,right];





function arr = pagesOrder(filename)
% arr = PAGESORDER(filename) returns the order of the pages for this chip to show the graph in the correct order
% filename	The file we parse for the data

fid = fopen(filename);
md = metaData(str2num(fgets(fid)));
numOfPages = md.pagesPerBlock;
str = fgets(fid);
fclose(fid);

if (md.testID == testID.errorMap)
    arr = str2num(str);
    
elseif(md.testID == testID.standardTest)   
    strarr = strsplit(str,'\t');
    strarr = strarr(2:2:(2*numOfPages));
    arr = zeros(1,size(strarr,2));
    for i = 1:size(strarr,2)
        str = strsplit(strarr{i},'_');
        arr(i) = str2double(str{2});
    end
    
    % functions that are using this function are expecting to get TLC pages
    % order in a format matching this scheme:
    % Low_pages, Middle_pages, High_pages.
    % for backward compatibility with old existing tests, the format as it
    % appears in the files is as follows:
    % low_left, low_right, mid_left, mid_right, high_left, high_right...
    % for example:
    % 01_0	10_0	01_258	10_258	01_1	10_1	01_259	10_259	01_2    10_2	01_260	10_260...
    % so we need to re-format it to the expected pages order format.
    if (md.architecture == architecture.tlc)
        mid_starting_index = size(arr,2)/3 + 1;
        high_starting_index = 2*mid_starting_index - 1;
        
       low_left = arr(1:6:end);
       low_right = arr(2:6:end);
       mid_left = arr(3:6:end);
       mid_right = arr(4:6:end);
       high_left = arr(5:6:end);
       high_right = arr(6:6:end);
       
       arr(1:2:mid_starting_index - 1) = low_left;
       arr(2:2:mid_starting_index - 1) = low_right;
       
       arr(mid_starting_index:2:high_starting_index - 1) = mid_left;
       arr(mid_starting_index + 1:2:high_starting_index - 1) = mid_right;
       
       arr(high_starting_index:2:end) = high_left;
       arr(high_starting_index + 1:2:end) = high_right;
    end
    
end
assert(size(arr,2)==md.pagesPerBlock, 'Reading pages order: line length does not match the expected length(number of pages)')
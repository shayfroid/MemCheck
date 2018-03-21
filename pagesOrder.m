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
   %{
    if (md.architecture == architecture.mlc)
        arr = reshape(arr,md.pagesPerBlock/2,2)';
    elseif (md.architecture == architecture.tlc)
        arr = reshape(arr,md.pagesPerBlock/3,3)';
    else
        err = sprintf('Unsupported aarchitecture: %d', md.architecture);
        msgbox(err,'Unsupported architecture'); 
    end
   %}
elseif(md.testID == testID.standardTest)   
    strarr = strsplit(str,'\t');
    strarr = strarr(2:2:(2*numOfPages));
    arr = zeros(1,size(strarr,2));
    for i = 1:size(strarr,2)
        str = strsplit(strarr{i},'_');
        arr(i) = str2double(str{2});
    end
end

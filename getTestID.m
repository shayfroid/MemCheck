function testID = getTestID(dirPath, filename)
%gets the testID from the metaData of a given file.
%dirpath - path to the directory where the file located.
% filename - the name of the file.

filepath = strcat(dirPath, filename);
fid = fopen(filepath);
metaData_ = metaData(str2num(fgets(fid)));
testID = metaData_.testID;
fclose(fid);

end


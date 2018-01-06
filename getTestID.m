function testID = getTestID(dirPath, filename)
%gets the testID from the metaData of a given file.
%

filepath = strcat(dirPath, filename);


fid = fopen(filepath);
metaData = metaData(str2num(fgets(fid)));
testID = metaData.testID;
fclose(fid);

end


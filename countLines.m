function count =  countLines(filename)
% count =  COUNTLINES(filename) return the number of lines in a file as count
% filename	the file to check and return it's number of lines
fid = fopen(filename);
meta = metaData(str2num(fgets(fid)));
fclose(fid);
%if num of PE cycles is givven by metaData
%if(size(meta,2) >= 8)
if (meta.numOfPECycles ~= -1)
    count = meta.numOfPECycles;
    return;
else
    s = 'type ';
    command = sprintf('%s%s%s',s,filename, ' | find "0" /c');
    [status,cmdout] = dos(command);

    % fid = fopen(filename);
    % meta = str2num(fgets(fid));
    % fclose(fid);
    
    % bit error map dont only have 1 non data line (meta data line). other 
    % files have 2 non data lines (metadata and header lines)
    if(meta.testID == 5)
        count = str2num(cmdout) - 1;
    else
        count = str2num(cmdout) - 2;
    end
end
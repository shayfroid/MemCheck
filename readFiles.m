function [m,meta,totalFilesRead,firstPath] = readFiles(filenames, path, numOfLines, handles)
% READFILES read all the test files and create the main structures
% [m,meta,totalFilesRead,firstPath] = READFILES(filenames, path)
% Returns a vector with all the structures we need for the test
% m					The main matrix which contains all the data
% meta				Class instance containing the metaData information about the test
% totalFilesRead	The number of files the user entered
% firstPath			The path to the location of the files
% There are two parameters to the function
% filenames			The name of the files to read, not includes full path
% path				The path to the diractory which has all the files. The application
%					requiers all the files to be in the same diractory

%if we are here filenames is not an empty array so no need to check that
%case
secondRead = any(strcmp(filenames,'(Full LLH)'));

if(~secondRead)
    if(ischar(filenames))
        s = strcat(path,filenames);
    else
        s = strcat(path,filenames{1});
    end
    firstPath = s;
    fid = fopen(s);
    meta = metaData(str2num(fgets(fid)));
    fclose(fid);
    %case trying to read LLH second part

    example = parseFile(s,meta.testID,numOfLines, handles);

    % check if the testID qualifies for autosum functionality
    autoSum = any(testID.autoSumTestID == meta.testID);
    if(autoSum)
        n = example;
    else
        n = {example};
    end

    totalFilesRead = 1;

%if we only have 1 file to read
    if(ischar(filenames))
        m = n;
        return;
    end
    startingIndex = 2;
else
    totalFilesRead = 1;
    startingIndex = 1;
    autoSum = false;
    meta = metaData();
    firstPath = '';
end

for i = startingIndex:size(filenames,2) 
    if(strcmp(filenames{i}, '(Full LLH)'))
        tmp_n = [];
    else
        s = strcat(path,filenames{i});
        tmp_n = parseFile(s,getTestID(path,filenames{i}), numOfLines, handles);
        if(~secondRead && ~isequal(size(example,2),size(tmp_n,2)))
            err = sprintf('Error reading files.\n %s have %d columns\n while other file\\s have %d.\n',...
                filenames{i},size(tmp_n,2),size(example,2));
            waitfor(msgbox(err,'Error in files consistency'));
            continue;
        end
    end
    if(autoSum)
        n = n + tmp_n;
    else
        n{i} = tmp_n;
    end
    totalFilesRead = totalFilesRead +1;
end
m = n;
if(autoSum)
    m = m./totalFilesRead;
end
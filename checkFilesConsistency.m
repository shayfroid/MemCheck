function  [numOfLines,consist,differentSizes,multipleTestID] = checkFilesConsistency(filenames, filepath,expectedTestID,firstRead)
% CHECKFILESCONSISTENCY Checks if the file is consistent and legal
% [numOfLines,consist] = CHECKFILESCONSISTENCY(filenames, filepath)
% Returns a tuple which contains the number of lines in the file (to know the number of P/E cycles) and a boolean flag that tells us if the file is legal
% The function go through all the files, check there metaData to see if it's legal, threre it go through the lines to see if the data inserted correctly.
% filenames	The names of the files, path is not included
% filepath	the path of all the files, which is mandatory to all to be in the same diractory
multipleTestID = false;
differentSizes = false;
if nargin == 2
    expectedTestID = testID.supportedTestID;
end

if (isa(filenames,'numeric'))
    numOfLines = 0;
    consist = false;
    return; 
end

filenames = setdiff(filenames,{'(Full LLH)'});
if(isempty(filenames))
        numOfLines = 0;
        consist = true;
        return; 
elseif(ischar(filenames))
        s = strcat(filepath,filenames);
else
        s = strcat(filepath,filenames{1}); 
end

fid = fopen(s);
local_metaData = metaData(str2num(fgets(fid)));


%Test for supported test ID
if(~any(testID.supportedTestID == local_metaData.testID))
    err = sprintf('Error. Test ID %d is not supported yet.\n',local_metaData.testID);
    msgbox(err,'Error reading files');
    consist = false;
    numOfLines = 0;
    return;
end
%Test for no more then 1 error map file loaded
if(local_metaData.testID == testID.errorMap && ~ischar(filenames) && size(filenames,2) > 1)
    err = sprintf('Error.\n Loading more then 1 file with test ID of 5 (Bit Eror Map) is not supported.\n');
    msgbox(err,'Error reading files');
    consist = false;
    numOfLines = 0;
    return;
end

%Test if loaded file coresponds to expected test id. 
if (~any(expectedTestID == local_metaData.testID))
     err = sprintf('Error. Expected files of test ID = %d.\n %s have testID of %d\n',...
            expectedTestID, s, local_metaData.testID);
    msgbox(err,'Error in files consistency');
    consist = false;
    numOfLines = 0;
    return
end
%test for loading testID of 4 before we have testID 3 loaded
if (firstRead && local_metaData.testID== testID.partialLLH2)
     err = sprintf('Error. Loaded test ID of 4 (partial LLH second part)\nbefore test ID 3 (partial LLH first part) was loaded.');
    msgbox(err,'Incorrect file loaded.');
    consist = false;
    numOfLines = 0;
    return
end

header = fgets(fid);
fclose(fid);
numOfLines = countLines(s);
if(ischar(filenames))
    consist = true;
    return;
end


if(any(testID.allowedMixing == local_metaData.testID) && firstRead)
    expectedTestID = testID.allowedMixing;
end

% check consistency of metadata, header and num of lines
for i = 2:size(filenames,2)
    s = strcat(filepath,filenames{i});
    fid = fopen(s);
    metaDataTmp = metaData(str2num(fgets(fid)));
    
    % check consistency of this file's meta data with the previous ones
    founderror = false;
    if (local_metaData.pagesPerBlock ~= metaDataTmp.pagesPerBlock)
        err = sprintf('Error in meta data comparison.\n%s have %d pages per block while previous files had %d.', ...
        filenames{i}, metaDataTmp.pagesPerBlock, local_metaData.pagesPerBlock);
        founderror = true;
    elseif (local_metaData.bytesPerPage ~= metaDataTmp.bytesPerPage)
        err = sprintf('Error in meta data comparison.\n%s have %d bytes per page  while previous files had %d.', ...
        filenames{i}, metaDataTmp.bytesPerPage, local_metaData.bytesPerPage);
        founderror = true;
    elseif (local_metaData.architecture ~= metaDataTmp.architecture)
        err = sprintf('Error in meta data comparison.\n%s have architecture of %d while previous files had %d.', ...
        filenames{i}, metaDataTmp.architecture, local_metaData.architecture);
        founderror = true;
    end
    
    if (founderror)
        consist = false;
        fclose(fid);
        msgbox(err,'Error in files consistency');
        return;
    end
    
    if(~any(expectedTestID == metaDataTmp.testID))
        expStr = sprintf('%d\\',expectedTestID);
        err = sprintf('Error reading files.\n %s have testID of %d\n while expecting only files with testID of %s',...
            filenames{i},metaDataTmp.testID,expStr(1:end-1));
        msgbox(err,'Error in files consistency');
        consist = false;
        fclose(fid);
        return;        
    end
    
    %here we are sure that the tmp testID is one of the expectedTesdID values so we can
    %compare it to the first one to see if we have mixing of files.  
    if(~multipleTestID && metaDataTmp.testID ~= local_metaData.testID)
        multipleTestID = true;
    end

    
    %checking if header line is equal (only for standard Test)
    if (local_metaData.testID == testID.standardTest && ~strcmp(fgets(fid),header))
         err =sprintf('Error in header comparison.\n file %s had different header than other fille\\s.',filenames{i});
        msgbox(err,'Error in files consistency');
        consist = false;
        fclose(fid);
        return;
    end
    tmpLines = countLines(s);
    if(tmpLines ~= numOfLines)
        %only relevant to testID 0 (standard test)
        if(any(testID.autoSumTestID ==  metaDataTmp.testID))            
            err =sprintf('Error in number of P\\E cycles comparison.\n file %s have different number of P\\E cycles than other file\\s.',filenames{i});
            msgbox(err,'Error in files consistency');
            consist = false;
            fclose(fid);
            return;
        else
            differentSizes = true;
            numOfLines = max(numOfLines, tmpLines);    
        end
    end
    fclose(fid);   
end
consist  = true;



function m = parseFile(filePath,testid, numOfLines)
% m = PARSEFILE(filePath, testid, numOfLines) parsing the file and fetch the data according to the test we check
%testID = getTestID(filePath);
switch testid
    case testID.standardTest
        m = dlmread(filePath,'\t',2,1);
    case {testID.fullLLH,testID.partialLLH1}
        m = dlmread(filePath,'\t',2,1);
        %n1 = n(:,1:metaData(3));
        %n2 = n(:,metaData(3)+1:2*metaData(3));
        %m = [n1+n2,n(:,2*metaData(3)+1:end)];
        m = m(:,2:4);
    case testID.partialLLH2
        m = dlmread(filePath,'\t',2,1);
        m = m(:,3:4);
        m = [zeros(size(m,1),1),m];
    case testID.errorMap
        m = readErrorMap(filePath,numOfLines);

    otherwise
        m = zeros(1,1);
%          err = sprintf('Error reading files.\n metaData for file:\n %s\n specifies test ID of %d which is not supported yet',...
%             filepath,metaData(6));
%         waitfor(msgbox(err,'Error in test ID')); 
        return;
end
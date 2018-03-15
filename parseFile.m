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
    % prompt for the type of reading (fast - assuming a cell will show 
    % error in only one of the bits it represents 
    % (if it represents bit X in pages A,B,C then we
    % will see an error only in one of the pages at X), or slow -without
    % that assumption, in that case if there is an erreo in multiple pages
    % (A and B for example) we will treat it as a single error. That
    % option requires contiuous sum of the error map and thus a lot slower
    % but more acuarate option.
    
    fast_description = 'fast: assuming each cell with an error\nwill only show an error in one of its represented pages.\n'
    slow_description = {'slow: no asumptions are made.'
                        'input validation is being performed on each cell'
                        'and if it is representing multiple bit errors in the same P/E cycle'
                        'they will all be considered as a single error.'}
    title = sprintf('%s\n',['which read method to use?',fast_description, slow_description{:}])
    read_method = questdlg(title,'Choose read method','fast','slow','fast')
        if (read_method == 'fast')
            m = readErrorMap(filePath,numOfLines);
        else
            m = readErrorMapCalibrated(filePath,numOfLines);
        end

    otherwise
        m = zeros(1,1);
%          err = sprintf('Error reading files.\n metaData for file:\n %s\n specifies test ID of %d which is not supported yet',...
%             filepath,metaData(6));
%         waitfor(msgbox(err,'Error in test ID')); 
        return;
end
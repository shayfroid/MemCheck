function m = parseFile(filePath,testid, numOfLines, handles)
% m = PARSEFILE(filePath, testid, numOfLines) parsing the file and fetch the data according to the test we check
% filepath - path to the file.
% testId - from metaData.
% numOfLines - number of P\E cycles in the file.
% handles - gui handles.

switch testid
    case testID.standardTest
        m = dlmread(filePath,'\t',2,1);
    case {testID.fullLLH,testID.partialLLH1}
        m = dlmread(filePath,'\t',2,1);
        m = m(:,2:4);
    case testID.partialLLH2
        m = dlmread(filePath,'\t',2,1);
        m = m(:,3:4);
        m = [zeros(size(m,1),1),m];
    case testID.errorMap
        graph_type = questdlg('Choose graph type','Choose graph type','Planes','Levels','Planes');

        if strcmp(graph_type, 'Levels')
           set(handles.errorMapButton, 'string', 'Bit Error Map (Levels)');   
        else
           set(handles.errorMapButton, 'string', 'Bit Error Map');
           set(handles.errorMapPairplanesCB, 'Enable', 'off');
           set(handles.errorMapPairplanesCB, 'value', 0);
        end

        numcores = feature('numcores');
        cache_path = py.ReadErrorMap_MP.read_error_map(filePath, pyargs('read_mode',lower(graph_type),'num_workers',int32(numcores)));
        m = cast(readNPY(char(cache_path)), 'double');
        
    otherwise
        m = zeros(1,1);
        return;
end
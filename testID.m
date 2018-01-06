classdef testID
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        supportedTestID = [0,2,3,4,5];
        autoSumTestID = [0,5];
        multipleFilesAllowedTestID = [0,2,3,4];
        allowedMixing = [2,3];
        mixSecondPart = [2,4];
        %emulating enum for test ID
        standardTest = 0;
        L_BiasedTest = 1;
        fullLLH = 2;
        partialLLH1 = 3;
        partialLLH2 = 4;
        errorMap = 5;
        LHH1 = 6;
        LHH2 = 7;
        
        
    end
    
    methods
        
    end
    
end


classdef metaData
    properties
        chipID;
        manufacturer;
        pagesPerBlock;
        bytesPerPage;
        blockNumber;
        testID;
        architecture;
        numOfPECycles;
    end
    
    methods
        function this = metaData(varargin)
            if nargin == 0
                this.chipID = -1;
                this.manufacturer = -1;
                this.pagesPerBlock = -1;
                this.bytesPerPage = -1;
                this.blockNumber = -1;
                this.testID = -1;
                this.architecture = -1;
                this.numOfPECycles = -1;

            elseif nargin == 1
                if (size(varargin{1}, 2) < 8)
                    msgbox('Ivalid Meta Data line. expected to find at least 8 values.');
                    return;
                end

                this.chipID = varargin{1}(1,1);
                this.manufacturer = varargin{1}(1,2);
                this.pagesPerBlock = varargin{1}(1,3);
                this.bytesPerPage = varargin{1}(1,4);
                this.blockNumber = varargin{1}(1,5);
                this.testID = varargin{1}(1,6);
                this.architecture = varargin{1}(1,7);
                this.numOfPECycles = varargin{1}(1,8);
            else
                if (nargin < 8)
                    msgbox('Ivalid Meta Data line. expected to find at least 8 values.');
                    return;
                end
                this.chipID = varargin{1};
                this.manufacturer = varargin{2};
                this.pagesPerBlock = varargin{3};
                this.bytesPerPage = varargin{4};
                this.blockNumber = varargin{5};
                this.testID = varargin{6};
                this.architecture = varargin{7};
                this.numOfPECycles = varargin{8};
            end 
        end
    end
    
end


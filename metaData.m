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
                assert(size(varargin{1}, 2) >=7)
                this.chipID = varargin{1}(1,1);
                this.manufacturer = varargin{1}(1,2);
                this.pagesPerBlock = varargin{1}(1,3);
                this.bytesPerPage = varargin{1}(1,4);
                this.blockNumber = varargin{1}(1,5);
                this.testID = varargin{1}(1,6);
                
                if size(varargin{1}, 2) >= 7
                    this.architecture = varargin{1}(1,7);
                else
                    this.architecture = -1;
                end
                
                if size(varargin{1}, 2) >= 8
                    this.numOfPECycles = varargin{1}(1,8);
                else
                    this.numOfPECycles = -1;
                end
                
            else
                this.chipID = varargin{1};
                this.manufacturer = varargin{2};
                this.pagesPerBlock = varargin{3};
                this.bytesPerPage = varargin{4};
                this.blockNumber = varargin{5};
                this.testID = varargin{6};
                
                if nargin >=7
                    this.architecture = varargin{7};
                else
                    this.architecture = -1;
                end
                
                if nargin >= 8
                    this.numOfPECycles = varargin{8};
                else
                    this.numOfPECycles = -1;
                end
            end 
        end
    end
    
end


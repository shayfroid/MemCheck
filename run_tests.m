function run_tests()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tests_path = 'tests';

test_files = dir(tests_path);
test_files = test_files(~ismember({test_files.name}, {'.','..'}));

tests_path = test_files(1).folder

expected_matrices_path = fullfile(tests_path,'expected_matrices');
tmp_results_location = fullfile(tests_path, 'tmp');
mkdir(tmp_results_location);

test_files = dir(tests_path);
test_files = test_files(~ismember({test_files.name}, {'.','..'}));

for i=1:length(test_files)
    test_input = fullfile(tests_path, test_files(i));
        res_path = py.ReadErrorMap_MP.read_error_map(filePath, pyargs('read_mode','planes','num_workers',int32(numcores), 'save_path', tmp_results_location));
        planes = cast(readNPY(char(res_path)), 'double');
        
        res_path = py.ReadErrorMap_MP.read_error_map(filePath, pyargs('read_mode','levels','num_workers',int32(numcores), 'save_path', tmp_results_location));
        levels = cast(readNPY(char(res_path)), 'double');
        


end


import sys
import os

file_path = sys.argv[1]
if not os.path.isfile(file_path):
    print(f'{file_path} does not exist or it is not a file.')
    exit(-1)

path, filename = os.path.split(file_path)
filename, ext = os.path.splitext(filename)

write_file_path = os.path.join(path, filename + f'_{sys.platform}{ext}')

with open(file_path, 'r') as fin:
    with open(write_file_path, 'w') as fout:
        for line in fin:
            fout.write(line.strip() + '\n')


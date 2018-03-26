import numpy as np
from numpy import zeros, concatenate, fromstring, uint32
import os
import hashlib
import time


READ_CHUNK_SIZE = 300*1024*1024
SUPPORTED_READ_MODES = ['normal', 'levels']

def calc_sha1(filepath):
	t1 = time.clock()
	_hash = hashlib.sha1()
	with open(filepath, 'rb') as f:
		while True:
			# we use the read passing the size of the block to avoid
			# heavy ram usage
			data = f.read(READ_CHUNK_SIZE)
			if not data:
				break
			# calculate partial hash (so far)
			_hash.update(data)
	return _hash.hexdigest()

	
def read_error_map(filepath, read_mode='normal', save_path=None):
	read_mode = read_mode.lower()
	print(read_mode)
	if read_mode not in SUPPORTED_READ_MODES:
		print('read_mode must be on of the following modes: {}. Got {}.'
				.format(' | '.join(SUPPORTED_READ_MODES), read_mode))
		exit(-1)
	
	path, filename = os.path.split(filepath)
	filename, ext = os.path.splitext(filename)
	
	# check if its a npy file and if the name matches the name structure we are expecting
	# if so - its already read and processed so we just return that file name
	if os.path.isfile(filepath) and filename.endswith('_mem_check_cache_' + read_mode):
		return filepath
	
	# filepath is not a _mem_check_cache.npy file.
	# calculate the sha1 function and check if a cache file already exist for that file
	_sha1 = calc_sha1(filepath)
	cache_file_name = filename + '_' + _sha1 + '_mem_check_cache_' + read_mode
	
	if save_path:
		cache_full_path = os.path.join(save_path, cache_file_name)
	else:
		cache_full_path = os.path.join(path, cache_file_name)

	if os.path.isfile(cache_full_path+'.npy'):
		return cache_full_path+'.npy'
	
	fid = open(filepath, 'r')
	meta = fromstring(fid.readline().strip(), dtype=int, sep='\t')
	
	pagesPerBlock = meta[2]
	bytesPerPage = meta[3]
	architecture = meta[6]
	
	pages_order = fromstring(fid.readline().strip(), dtype=int, sep='\t')
	
	if architecture == 0:  # mlc
		summed_errors = zeros((int(pagesPerBlock / 2), bytesPerPage * 8), 'uint32')
		pages_coupling = pages_order.reshape((int(pagesPerBlock / 2), 2), order='F')
	else:  # tlc
		summed_errors = zeros((int(pagesPerBlock / 3), bytesPerPage * 8), 'uint32')
		pages_coupling = pages_order.reshape((int(pagesPerBlock / 3), 3), order='F')
	
	m = zeros((pagesPerBlock, bytesPerPage * 8), 'uint32')
	
	line = 'dummy string'
	while line:
		line = fid.readline()
		if read_mode == 'normal':
			# in normal read mode we need to reset m each line that we read in order to be able to detect
			# if a cell error caused bit error  in more then one page.
			m = zeros((pagesPerBlock, bytesPerPage * 8), 'uint32')
			
		arr = fromstring(line.strip(), dtype=uint32, sep='\t')
		i = 1
		length = arr.shape[0]
		
		while i < length:
			page = arr[i]
			i = i + 1
			bits = arr[i + 1:i + arr[i] + 1]
			i = i + arr[i] + 1
			bits = concatenate((bits, arr[i + 1:i + arr[i] + 1]))
			i = i + arr[i] + 1
			if read_mode == 'normal':
				m[page, bits] = 1
			elif read_mode == 'levels':
				m[page, bits] += 1
			else:
				raise NotImplemented
		
		if read_mode == 'normal':
			summed_errors_per_loop = zeros(summed_errors.shape, 'uint32')
			i = 0
			while i < pages_coupling.shape[0]:
				summed_errors_per_loop[i, :] = (m[pages_coupling[i, :], :]).sum(axis=0)
				i += 1

			summed_errors_per_loop[(summed_errors_per_loop > 1)] = 1
			summed_errors += summed_errors_per_loop
		
	fid.close()
	if read_mode == 'normal':
			left = summed_errors[0::2, :]
			right = summed_errors[1::2, :]
	else:
		if architecture == 0:
			left_low = m[pages_order[0:int(pagesPerBlock/2):2], :]
			right_low = m[pages_order[1:int(pagesPerBlock/2):2], :]
			left_high = m[pages_order[int(pagesPerBlock/2)::2], :]
			right_high = m[pages_order[int(pagesPerBlock/2)+1::2], :]
			
			left = np.concatenate((left_low,left_high))
			right = np.concatenate((right_low, right_high))
		else:
			left_low = m[pages_order[0:int(pagesPerBlock/3):2], :]
			right_low = m[pages_order[1:int(pagesPerBlock/3):2], :]
			left_middle = m[pages_order[int(pagesPerBlock/3):2*int(pagesPerBlock/3):2], :]
			right_middle = m[pages_order[int(pagesPerBlock/3)+1:2*int(pagesPerBlock/3):2], :]
			left_high = m[pages_order[2*int(pagesPerBlock/3)::2], :]
			right_high = m[pages_order[2*int(pagesPerBlock/3)+1::2], :]
			
			left = np.concatenate((left_low, left_middle, left_high))
			right = np.concatenate((right_low, right_middle, right_high))
		
	np.save(cache_full_path, np.concatenate((left, right), axis=1))
		
	return cache_full_path + '.npy'

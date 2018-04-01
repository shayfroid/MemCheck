import numpy as np
from numpy import zeros, concatenate, fromstring, uint32
import os
import hashlib
import time
import multiprocessing as mpr
import ctypes

READ_CHUNK_SIZE = 300 * 1024 * 1024
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


def read_error_map_worker(lines_q, result_arr, result_dimensions, read_mode, filepath):
	fid = open(filepath, 'r')
	
	meta = fromstring(fid.readline().strip(), dtype=int, sep='\t')
	
	pages_per_block = int(meta[2])
	bytes_per_page = int(meta[3])
	architecture = int(meta[6])
	
	pages_order = fromstring(fid.readline().strip(), dtype=int, sep='\t')
	
	if architecture == 0:  # mlc
		summed_errors = zeros((int(pages_per_block / 2), bytes_per_page * 8), 'uint16')
		pages_coupling = pages_order.reshape((int(pages_per_block / 2), 2), order='F')
	else:  # tlc
		summed_errors = zeros((int(pages_per_block / 3), bytes_per_page * 8), 'uint16')
		pages_coupling = pages_order.reshape((int(pages_per_block / 3), 3), order='F')
	
	m = zeros((pages_per_block, bytes_per_page * 8), 'uint16')
	
	prev_line = 0
	while True:
		line_num = lines_q.get()
		if line_num is None:
			break
		# skip to the next line to read
		for _ in range(line_num-(prev_line+1)):
			fid.readline()
		line = fid.readline()
		prev_line = line_num
		
		if read_mode == 'normal':
			# in normal read mode we need to reset m each line that we read in order to be able to detect
			# if a cell error caused bit error  in more then one page.
			m = zeros((pages_per_block, bytes_per_page * 8), 'uint16')
		
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
			i = 0
			while i < pages_coupling.shape[0]:
				summed_errors_per_loop = (m[pages_coupling[i, :], :]).sum(axis=0)
				summed_errors_per_loop[(summed_errors_per_loop > 1)] = 1
				summed_errors[i] += summed_errors_per_loop
				i += 1
			
	fid.close()
	
	if read_mode == 'normal':
		left = summed_errors[0::2, :]
		right = summed_errors[1::2, :]
	else:
		if architecture == 0:
			left_low = m[pages_order[0:int(pages_per_block / 2):2], :]
			right_low = m[pages_order[1:int(pages_per_block / 2):2], :]
			left_high = m[pages_order[int(pages_per_block / 2)::2], :]
			right_high = m[pages_order[int(pages_per_block / 2) + 1::2], :]
			
			left = np.concatenate((left_low, left_high))
			right = np.concatenate((right_low, right_high))
		else:
			left_low = m[pages_order[0:int(pages_per_block / 3):2], :]
			right_low = m[pages_order[1:int(pages_per_block / 3):2], :]
			left_middle = m[pages_order[int(pages_per_block / 3):2 * int(pages_per_block / 3):2], :]
			right_middle = m[pages_order[int(pages_per_block / 3) + 1:2 * int(pages_per_block / 3):2], :]
			left_high = m[pages_order[2 * int(pages_per_block / 3)::2], :]
			right_high = m[pages_order[2 * int(pages_per_block / 3) + 1::2], :]
			
			left = np.concatenate((left_low, left_middle, left_high))
			right = np.concatenate((right_low, right_middle, right_high))
		
	res = np.ctypeslib.as_array(result_arr.get_obj())
	res.shape = result_dimensions

	with result_arr.get_lock():
		print(f'{mpr.current_process().pid} updating result')
		res[:] += np.concatenate((left, right), axis=1)
		print(f'{mpr.current_process().pid} done')


def read_error_map(filepath, read_mode='normal', save_path=None, num_workers=None):
	t1 = time.clock()
	if read_mode not in SUPPORTED_READ_MODES:
		print('read_mode must be on of the following modes: {}. Got {}.'
				.format(' | '.join(SUPPORTED_READ_MODES), read_mode))
		exit(-1)
	
	path, filename = os.path.split(filepath)
	filename, ext = os.path.splitext(filename)
	
	# check if its an npy file and if the name matches the name structure we are expecting
	# if so - its already read and processed so we just return that file name
	if os.path.isfile(filepath) and filename.endswith('_mem_check_cache_' + read_mode):
		return filepath
	
	# filepath is not a _mem_check_cache.npy file.
	# calculate the sha1 function and check if a cache file already exist for that file
	_sha1 = calc_sha1(filepath)
	cache_file_name = filename + '_' + _sha1 + '_mem_check_cache_' + read_mode + '_line_numbers'
	
	if save_path:
		cache_full_path = os.path.join(save_path, cache_file_name)
	else:
		cache_full_path = os.path.join(path, cache_file_name)
	
	if os.path.isfile(cache_full_path + '.npy'):
		return cache_full_path + '.npy'
	
	fid = open(filepath, 'r')
	meta = fromstring(fid.readline().strip(), dtype=int, sep='\t')
	
	pages_per_block = int(meta[2])
	bytes_per_page = int(meta[3])
	architecture = int(meta[6])
	
	# skip "pages order" line
	fid.readline()
	
	manager = mpr.Manager()
	lines_q = manager.Queue()

	if read_mode == 'normal':
		if architecture == 0:# mlc
			lines_count = int(pages_per_block/4)
		else:
			lines_count = int(pages_per_block/6)
	else:
		lines_count = int(pages_per_block/2)
		
	result_dimensions = (lines_count, bytes_per_page*2*8)
	
	# * 8 for the number of bits, *2 for the left, right pages split of the result
	result_arr = mpr.Array(ctypes.c_uint32, lines_count*bytes_per_page*2*8)
	workers = []
	if not num_workers:
		num_workers = os.cpu_count()
	for i in range(num_workers):
		p = mpr.Process(target=read_error_map_worker, args=(lines_q, result_arr, result_dimensions, read_mode, filepath))
		p.start()
		workers.append(p)
	
	for i, _ in enumerate(fid):
		lines_q.put(i+1)

	for _ in workers:
		lines_q.put(None)
		
	for p in workers:
		p.join()

	fid.close()
	
	res = np.ctypeslib.as_array(result_arr.get_obj())
	res.shape = result_dimensions
	
	np.save(cache_full_path, res)
	
	print(f'time: {time.clock()-t1}')
	print(cache_full_path + '.npy')
	
	return cache_full_path + '.npy'

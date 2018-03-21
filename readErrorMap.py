import numpy as np
from numpy import zeros, array, arange, concatenate, fromstring, uint32
import time


def readerrormap(filepath):
	fid = open(filepath, 'r')
	line = fid.readline()
	
	meta = fromstring(line.strip(), dtype=int, sep='\t')
	m = zeros((meta[2], meta[3] * 8), 'uint32')
	
	if meta[1] == 0:
		pass
	# summed_errors = np.zeros((meta[2] / 2, meta[3] * 8), 'int32')
	# pages_order = pagesOrderHynix(meta.architecture, meta.pagesPerBlock);
	# pages_coupling = reshape(pages_order, meta.pagesPerBlock / 2, 2);
	elif meta[1] == 1:
		summed_errors = zeros((int(meta[2] / 3), meta[3] * 8), 'uint32')
		pages_order = array([
			concatenate((arange(0, 258, 3), arange(1, 258, 3), arange(2, 258, 3))),
			concatenate((arange(258, 516, 3), arange(259, 516, 3), arange(260, 516, 3)))
		])
		pages_coupling = pages_order.reshape((int(meta[2] / 3), 3), order='F')
	
	else:
		pass
	iteration = 0
	while line:
		iteration = iteration + 1
		line = fid.readline()
		m = zeros((meta[2], meta[3] * 8), 'uint32')
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
			m[page, bits] = 1

		summed_errors_per_loop = zeros(summed_errors.shape, 'uint32')
		i = 0
		while i < pages_coupling.shape[0]:
			summed_errors_per_loop[i, :] = (m[pages_coupling[i, :], :]).sum(axis=0)
			i += 1
		
		summed_errors_per_loop[(summed_errors_per_loop > 1)] = 1
		summed_errors += summed_errors_per_loop
	
	fid.close()
	np.save('npsave', summed_errors)
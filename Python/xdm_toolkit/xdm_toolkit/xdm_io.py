__copyright__ = '2017 Frankie Li. All Rights Reserved.'
__author__ = 'Frankie Li'

""" XDM input output library.

    MIC file format is a historical format from CMU's 
    high energy x-ray diffraction microscopy group.
	
	Purpose:
	Load a *.mic or *.LBFS file
	Copyright Frankie Li, 2017
"""

import numpy as np

def load_mic(filename):
	with open(filename) as fd:
		sidewidth = float(fd.readline())
		snp = np.loadtxt(fd)
		return snp, sidewidth
	# Let python raise the exception


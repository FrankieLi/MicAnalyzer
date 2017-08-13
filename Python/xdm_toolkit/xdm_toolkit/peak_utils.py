__copyright__ = '2017 Frankie Li. All Rights Reserved.'
__author__ = 'Frankie Li'

""" Utilities to analyze I9 reduced data.
"""

import matplotlib.pyplot as plt
import numpy as np

def plot_peaks(peak_list):

    for p in peak_list:
        plt.plot(p.x, p.y, 'k.')
    plt.gca().invert_yaxis()
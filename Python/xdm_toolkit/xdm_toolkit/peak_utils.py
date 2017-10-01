__copyright__ = '2017 Frankie Li. All Rights Reserved.'
__author__ = 'Frankie Li'

""" Utilities to analyze I9 reduced data.
"""

import matplotlib.pyplot as plt
import numpy as np

def plot_peaks(peak_list, plot_option, figure=None):

    if figure is None:
        figure = plt.figure()

    for p in peak_list:
        plt.plot(p.x, p.y, plot_option)

    return figure
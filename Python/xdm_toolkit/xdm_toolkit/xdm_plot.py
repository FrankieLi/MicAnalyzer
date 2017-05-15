__copyright__ = '2017 Frankie Li. All Rights Reserved.'
__author__ = 'Frankie Li'

""" XDM visualiation library.
"""

from xdm_toolkit import xdm_assert as xassert
from xdm_toolkit import mic_util as utils

import numpy as np
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection
import matplotlib.pyplot as plt


def plot_mic(snp, sidewidth, plot_opt, confidence):
    """
        Main plot driver.
    """
    vertices, data = utils.generate_vertices(snp, sidewidth)

    plot_patch(vertices, np.squeeze(data[:, 4:7]))


def plot_patch(vertices, color):

    patches = []
    for verts in vertices:
        tri = Polygon(verts.reshape((3, 2)), True)
        patches.append(tri)
    
    p = PatchCollection(patches, alpha=0.4)
    colors = color
    p.set_array(np.array(colors))
    fig, ax = plt.subplots()
    ax.add_collection(p)
    fig.colorbar(p, ax=ax)
    plt.show()



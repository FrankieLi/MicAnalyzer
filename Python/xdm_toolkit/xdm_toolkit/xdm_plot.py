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

    if plot_opt == 2:
        fig, ax, im = plot_scalar_patch(vertices, data[:, 9])
    else:
        # To be refactored to other types of plot.
        colors = get_euler_color(data[:, 4:7])
        fig, ax, im = plot_patch(vertices, colors)

    # Standard centering
    axes = fig.gca()
    axes.set_xlim([-1 * sidewidth, sidewidth])
    axes.set_ylim([-1 * sidewidth, sidewidth])
    plt.show(block=False)

    return fig, ax, im


def plot_scalar_patch(vertices, scalar, color_map=plt.cm.hot):
    """ Plot scalar field on patches defined by vertices.
    Note: scalar must be a sclar field! Otherwise, color map doesn't make
    any sense!
    """
    patches = [Polygon(v.reshape((3, 2)), True) for v in vertices]
    p = PatchCollection(patches, cmap=color_map)
    p.set_array(np.array(scalar))
    fig, ax = plt.subplots()
    im = ax.add_collection(p)
    fig.colorbar(im, ax=ax)
    return fig, ax, im


def plot_patch(vertices, colors):

    patches = [Polygon(v.reshape((3, 2)), True) for v in vertices]
    p = PatchCollection(patches)
    p.set_color(colors)
    fig, ax = plt.subplots()
    im = ax.add_collection(p)
    fig.colorbar(im, ax=ax)
    return fig, ax, im


def get_confidence_color(conf):
    colors = np.vstack([conf, conf, conf]).T
    return colors


def get_euler_color(euler_angles):
    # assert euler_angles to be n x 3 matrix here.
    colors = np.squeeze(euler_angles)
    colors = [c/360.0 for c in colors]
    return colors

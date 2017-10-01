__copyright__ = '2017 Frankie Li. All Rights Reserved.'
__author__ = 'Frankie Li'

""" XDM visualiation library.
"""

from xdm_toolkit import xdm_assert as xassert
from xdm_toolkit import mic_util as utils
from hexrd import orientations as orientlib

import copy
import numpy as np
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection
from matplotlib.collections import PolyCollection
import matplotlib.pyplot as plt

"""
    We need to refactor the mathematical functions out.
"""
def axis_angle_to_RF(axis_angle_pair):
    """ Convert from axis angle to Rodriguiz (RF) Vector."""
    n_hat, theta = axis_angle_pair
    half_angle = theta/2.0
    return np.array(n_hat) * np.tan(half_angle)


def get_rf_vector(euler_angles):
    xassert.runtime_assert(np.shape(euler_angles)[1] == 3,
                           'Expected n x 3 array')

    def euler_to_RF(e):
        return axis_angle_to_RF(orientlib.matToThetaN(orientlib.bungeToMat(e)))
    return np.array([euler_to_RF(np.radians(e)) for e in euler_angles])


def plot_mic(snp, sidewidth, plot_opt, confidence):
    """
        Main plot driver.
    """
    snp = filter_by_confidence(snp, confidence)

    vertices, data = utils.generate_vertices(snp, sidewidth)

    if plot_opt == 2:
        fig, ax, im = plot_scalar_patch(vertices, data[:, 9])
    else:
        if plot_opt == 3:
            rf_vec = get_rf_vector(data[:, 4:7])
            snp_colors = get_RF_color(rf_vec)
        else:
            # To be refactored to other types of plot.
            snp_colors = get_euler_color(data[:, 4:7])
        fig, ax, im = plot_color_patch(vertices, snp_colors)

    # Standard centering
    axes = fig.gca()
    axes.set_xlim([-1 * sidewidth, sidewidth])
    axes.set_ylim([-1 * sidewidth, sidewidth])

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


def plot_color_patch(vertices, colors):

    patches = [Polygon(v.reshape((3, 2)), True) for v in vertices]
    p = PatchCollection(patches)
    p.set_color(colors)
    fig, ax = plt.subplots()
    im = ax.add_collection(p)
    # fig.colorbar(im, ax=ax)
    return fig, ax, im


def get_confidence_color(conf):
    colors = np.vstack([conf, conf, conf]).T
    return colors

def get_euler_color(euler_angles):
    # assert euler_angles to be n x 3 matrix here.
    colors = np.squeeze(euler_angles)
    colors = [c/360.0 for c in colors]
    return colors

def get_RF_color(rf_vec):
    """ Mapping RF space to color in a standard (historical) way.
    """
    color = copy.deepcopy(rf_vec)

    def renormalize(v):
        v -= np.min(v)
        return v / np.max(v)

    for i in xrange(3):
        color[:, i] = renormalize(color[:, i])
    return color

def filter_by_confidence(snp, conf_thresh):
    return np.squeeze(snp[np.where(snp[:, 9] > conf_thresh), :])

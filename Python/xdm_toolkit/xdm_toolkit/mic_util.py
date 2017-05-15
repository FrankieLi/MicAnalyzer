__copyright__ = '2017 Frankie Li. All Rights Reserved.'
__author__ = 'Frankie Li'

""" Mic file geometry and processing.
"""
import numpy as np
from xdm_toolkit import xdm_assert as xassert


def generate_vertices(mic_snp, sidewidth):

    T_GEN_IDX = 4  # Triangle generation index.
    T_DIR_IDX = 3  # Triangle direction index.

    tri_gen = 2.0 ** mic_snp[:, T_GEN_IDX]
    down_idx = (mic_snp[:, T_DIR_IDX] > 1).nonzero()
    up_idx = (mic_snp[:, T_DIR_IDX] <= 1).nonzero()
    ups_sidewidth = sidewidth / tri_gen[up_idx]
    downs_sidewidth = sidewidth / tri_gen[down_idx]

    up_vert = gen_vertex_helper(np.squeeze(
        mic_snp[up_idx, 0:2]), ups_sidewidth, points_up=True)
    down_vert = gen_vertex_helper(np.squeeze(
        mic_snp[down_idx, 0:2]), downs_sidewidth, points_up=False)

    up_data = np.squeeze(mic_snp[up_idx, 2:])
    down_data = np.squeeze(mic_snp[down_idx, 2:])

    return np.vstack((up_vert, down_vert)), np.vstack((up_data, down_data))


def gen_vertex_helper(left_vert, sw_list, points_up):

    # import pdb; pdb.set_trace()
    # Here be type check and dimension check.
    xassert.runtime_assert(len(left_vert.shape) == 2 and
                           left_vert.shape[1] == 2,
                           'Error: vertex expected to be 2 dimensional.')
    v1 = left_vert
    v2 = left_vert
    v2[:, 0] += sw_list

    v3 = left_vert
    v3[:, 0] += sw_list / 2.0
    if points_up:
        v3[:, 1] += sw_list / 2.0 * np.sqrt(3)
    else:
        v3[:, 1] -= sw_list / 2.0 * np.sqrt(3)

    return np.hstack((v1, v2, v3))

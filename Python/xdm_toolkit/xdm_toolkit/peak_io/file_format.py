__copyright__ = '2017 Frankie Li. All Rights Reserved.'
__author__ = 'Frankie Li'

""" XDM file format and convertion library.
"""
from glob import glob
import numpy as np
from pathlib import Path

import struct
from xdm_toolkit import xdm_assert as xassert


class FileException(Exception):
    pass


class UFFHeader(object):
    """ Universal file format header."""

    def __init__(self):
        self.block_type = 0
        self.data_format = 0
        self.num_children = 0
        self.name_size = 0
        self.block_name = 0
        self.data_size = 0
        self.chunk_number = 0
        self.total_chunks = 0


def get_uint16(fd):
    return struct.unpack('H', fd.read(2))[0]


def get_uint16_list(fd, len):
    int_list = []
    for i in xrange(len):
        int_list.append(get_uint16(fd))
    return int_list


def get_uint32(fd):
    return struct.unpack('I', fd.read(4))[0]


def get_float32(fd):
    return struct.unpack('f', fd.read(4))[0]


def get_float32_list(fd, len):
    float_list = []
    for i in xrange(len):
        float_list.append(get_float32(fd))
    return float_list


def get_char(fd):
    return struct.unpack('c', fd.read(1))[0]


def get_string(fd, len):
    string = []
    for i in xrange(len):
        string.append(get_char(fd))
    return ''.join(string)


class peak_data(object):

    def __init__(self, x, y, intensity, peak_id):
        self.x = np.array(x)
        self.y = np.array(y)
        self.intensity = np.array(intensity)
        self.peak_id = np.array(peak_id)


class I9PeakReader(object):
    """ Standard IceNine binary peak file. This is built on top of UFF binary
    files.
    """

    def __init__(self):
        pass

    def read_UFF_header(self, fd):
        hdr = UFFHeader()

        # Read uint32 that should be FEEDBEEF
        block_hdr = get_uint32(fd)
        if int(block_hdr) != int('FEEDBEEF', 16):
            raise FileException('UFF File corrupted')

        hdr.block_type = get_uint16(fd)
        hdr.data_format = get_uint16(fd)

        hdr.num_children = get_uint16(fd)
        hdr.name_size = get_uint16(fd)
        hdr.data_size = get_uint32(fd)

        hdr.chunk_number = get_uint16(fd)
        hdr.total_chunks = get_uint16(fd)
        hdr.block_name = get_string(fd, hdr.name_size)

        return hdr

    def read_uff_peak(self, filename):
        with open(filename, 'rb') as fd:
            # float32 version number
            version_number = get_float32(fd)
            hdr_main = self.read_UFF_header(fd)

            # Read children data location.
            child_x_loc = get_uint32(fd)
            child_y_loc = get_uint32(fd)
            child_int_loc = get_uint32(fd)
            child_peak_loc = get_uint32(fd)

            num_peaks = get_uint32(fd)

            # Read x coordinate.
            hdr1 = self.read_UFF_header(fd)
            num_elements = (hdr1.data_size - hdr1.name_size) / 2
            x_list = get_uint16_list(fd, num_elements)

            # Read y coordinate.
            hdr1 = self.read_UFF_header(fd)
            num_check = (hdr1.data_size - hdr1.name_size) / 2
            xassert.runtime_assert(num_check == num_elements,
                                   'Peak file seems to be corruped.')
            y_list = get_uint16_list(fd, num_elements)

            # Read intensity.
            hdr1 = self.read_UFF_header(fd)
            num_check = (hdr1.data_size - hdr1.name_size) / 4
            xassert.runtime_assert(num_check == num_elements,
                                   'Peak file seems to be corruped.')
            intensity_list = get_float32_list(fd, num_elements)

            # Read peak ID.
            hdr1 = self.read_UFF_header(fd)
            num_check = (hdr1.data_size - hdr1.name_size) / 2
            xassert.runtime_assert(num_check == num_elements,
                                   'Peak file seems to be corruped.')
            peak_id_list = get_uint16_list(fd, num_elements)

            return (x_list, y_list, intensity_list, peak_id_list)

    def load_file(self, filename):
        x, y, intensity, peak_id = self.read_uff_peak(filename)
        p = peak_data(x, y, intensity, peak_id)
        return p

    def load_dir(self, input_dir, num_L_dist):
        """ Load all reduced file from a specified director.
            `input_dir` - input directory containing the reduced data set.
            `num_L_dist` - number of detector distances.
        """

        file_lists = []
        for n in xrange(num_L_dist):
            p = Path(input_dir) / Path('*bin' + str(n))
            files = glob(str(p))
            file_lists.append(files)

        file_counts = [len(f) for f in file_lists]
        xassert.runtime_assert(len(np.unique(file_counts)) == 1,
                               'Number of files mismatched in the data reduction directory.')

        peak_list = [[] for l in file_counts]

        for n in xrange(num_L_dist):
            for p in file_lists[n]:
                peak_list[n].append(self.load_file(p))
        return peak_list

    def load_files(self, input_dir, prefix, num_digits, idx_range, num_L_dist):
        ''' Load files based on pattern:
            prefix<serial_number>.bin<L_dist>

            `input_dir` - Input directory.
            `prefix` - File prefix.
            `num_digits` - Number of digits in the serial number.
            `idx_range` - A size two list like object designating start and
                          stop, exclusively [start, stop).
            `num_L_dist` - Number of L distances.
        '''

        xassert.runtime_assert(len(idx_range) == 2,
                               'idx_range expected to have two elements.')

        peak_list = [[] for l in xrange(num_L_dist)]
        for n in xrange(num_L_dist):
            for idx in xrange(idx_range[0], idx_range[1]):
                filename = (prefix + str(idx).zfill(num_digits)
                            + '.bin' + str(n))
                p = Path(input_dir) / Path(filename)
                peak_list[n].append(self.load_file(str(p)))
        return peak_list

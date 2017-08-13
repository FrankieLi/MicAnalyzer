__copyright__ = '2017 Frankie Li. All Rights Reserved.'
__author__ = 'Frankie Li'

""" XDM file format and convertion library.
"""

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

    def read(self, filename):
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


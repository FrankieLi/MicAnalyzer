__copyright__ = '2017 Frankie Li. All Rights Reserved.'
__author__ = 'Frankie Li'

"""xdm_toolkit."""

import os

from setuptools import find_packages, setup

with open(os.path.join(os.path.dirname(__file__), 'README.md')) as readme:
    README = readme.read()

# Allow setup.py to be run from any path
os.chdir(os.path.normpath(os.path.join(os.path.abspath(__file__), os.pardir)))

setup(
    name='xdm-toolkit',
    version='0.1.0',
    packages=find_packages(),
    include_package_data=True,
    description='XDM Toolkit',
    long_description=README,
    license=__copyright__,
    url='none yet',
    author=__author__,
    author_email='sfli@alumni.cmu.edu',
    classifiers=[
        'Intended Audience :: Developers',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
    ],
)
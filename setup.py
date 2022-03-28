import setuptools
from distutils.core import setup
from Cython.Build import cythonize

setup(
    # Build both
    ext_modules=cythonize(["tercontrol.pyx", "terminfo.pyx"]),
    
    # Build `tercontrol.pyx`
    #ext_modules=cythonize("tercontrol.pyx"),
 
    # Build `terminfo.pyx`
    #ext_modules=cythonize("terminfo.pyx"),
)

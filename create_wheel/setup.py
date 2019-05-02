import setuptools


with open("README.md", "r") as fh:
    long_description = fh.read()


# This creates a list which is empty but returns a length of 1.
# Should make the wheel a binary distribution and platlib compliant.
#<https://github.com/skvark/opencv-python/blob/master/setup.py>
class EmptyListWithLength(list):
    def __len__(self):
        return 1


setuptools.setup(
    name="opencv-python-inference-engine",
    version="4.1.1.0",
    url="https://github.com/banderlog/opencv-python-inference-engine",
    maintainer="Kabakov Borys",
    license='MIT, BSD',
    description="Wrapper package for OpenCV 4 #e28e3c9 with Inference Engine 2019_R1.0.1 python bindings",
    long_description=long_description,
    long_description_content_type="text/markdown",
    ext_modules=EmptyListWithLength(),
    packages=['cv2'],
    package_data={'cv2': ['*.so']},
    include_package_data=True,
    install_requires=['numpy'],
    classifiers=[
        'Development Status :: 4 - Beta',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Intended Audience :: Education',
        'Intended Audience :: Information Technology',
        'Intended Audience :: Science/Research',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: C++',
        'Operating System :: POSIX :: Linux',
        'Topic :: Scientific/Engineering',
        'Topic :: Scientific/Engineering :: Image Recognition',
        'Topic :: Software Development',
    ],
)

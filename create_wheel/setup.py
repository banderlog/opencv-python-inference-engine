import setuptools


with open("README.md", "r") as fh:
    long_description = fh.read()


# This creates a list which is empty but returns a length of 1.
# Should make the wheel a binary distribution and platlib compliant.
# from <https://github.com/skvark/opencv-python/blob/master/setup.py>
class EmptyListWithLength(list):
    def __len__(self):
        return 1


setuptools.setup(
    name='opencv-python-inference-engine',
    version='2021.11.27',
    url="https://github.com/banderlog/opencv-python-inference-engine",
    maintainer="Kabakov Borys",
    license='MIT, Apache 2.0',
    description="Wrapper package for OpenCV with Inference Engine python bindings",
    long_description=long_description,
    long_description_content_type="text/markdown",
    ext_modules=EmptyListWithLength(),
    packages=['cv2'],
    package_data={'cv2': ['*.so*', '*.mvcmd', '*.xml']},
    include_package_data=True,
    install_requires=['numpy'],
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Intended Audience :: Education',
        'Intended Audience :: Information Technology',
        'Intended Audience :: Science/Research',
        'Programming Language :: Python :: 3',
        'Programming Language :: C++',
        'Operating System :: POSIX :: Linux',
        'Topic :: Scientific/Engineering',
        'Topic :: Scientific/Engineering :: Image Recognition',
        'Topic :: Software Development',
    ],
)

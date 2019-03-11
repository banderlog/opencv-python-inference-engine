import setuptools


with open("README.md", "r") as fh:
    long_description = fh.read()


setuptools.setup(
    name="opencv-python-inference-engine",
    version="4.0.1.2",
    url="https://github.com/banderlog/opencv-python-inference-engine",
    maintainer="Kabakov Borys",
    license='MIT, BSD',
    description="Wrapper package for OpenCV with Inference Engine python bindings",
    long_description=long_description,
    long_description_content_type="text/markdown",
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
        'Operating System :: POSIX',
        'Operating System :: Unix',
        'Topic :: Scientific/Engineering',
        'Topic :: Scientific/Engineering :: Image Recognition',
        'Topic :: Software Development',
    ],
)

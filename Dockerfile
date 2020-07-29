# Start from official jupyter Docker image (https://hub.docker.com/r/jupyter/scipy-notebook)
FROM jupyter/scipy-notebook:ubuntu-18.04

# Switch to root
USER root

# Building OpenCV from source with non-free packages on
# sources: https://www.pyimagesearch.com/2018/05/28/ubuntu-18-04-how-to-install-opencv/
# sources: https://github.com/fgiuste7/Docker/blob/master/ComputerVision/Dockerfile
RUN apt-get update -yq
RUN apt-get install -yq --no-install-recommends apt-utils

# install developer tools
RUN apt-get install -yq --no-install-recommends build-essential cmake unzip pkg-config

# install image processing / computer vision libraries
RUN apt-get install -yq --no-install-recommends libjpeg-dev libpng-dev libtiff-dev

# install add-apt
RUN apt-get install -yq --no-install-recommends software-properties-common
RUN apt-get update -yq

# install libjasper-dev
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
RUN apt update -yq
RUN apt-get install -yq --no-install-recommends libjasper1 libjasper-dev

# install video I/O packages
RUN apt-get install -yq --no-install-recommends libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
RUN apt-get install -yq --no-install-recommends libxvidcore-dev libx264-dev

# install GTK
RUN apt-get install -yq --no-install-recommends libgtk-3-dev

# install libraries for optimizing various OpenCV functions
RUN apt-get install -yq --no-install-recommends libatlas-base-dev gfortran
RUN apt-get install -yq --no-install-recommends

# download sources for OpenCV build
WORKDIR /
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.9.zip
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.4.9.zip

# unzip dirs
RUN unzip opencv.zip && mv opencv-3.4.9 opencv
RUN unzip opencv_contrib.zip && mv opencv_contrib-3.4.9 opencv_contrib

# install python-dev and python-numpy to avoid errors
RUN apt-get install -yq --no-install-recommends python-dev
RUN apt-get install -yq --no-install-recommends python-numpy

# cmake build
RUN mkdir /opencv/build
WORKDIR /opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D PYTHON3_EXECUTABLE=/opt/conda/bin/python \
    -D PYTHON_INCLUDE_DIR=/opt/conda/include/python3.7m \
    -D PYTHON_LIBRARY=/opt/conda/lib/libpython3.7m.so \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D BUILD_EXAMPLES=ON ..

# run make of build
RUN make -j12
RUN make install
RUN ldconfig

# change the name of the OpenCV so file
WORKDIR /usr/local/lib/python3.7/site-packages/cv2/python-3.7/
RUN mv cv2.cpython-37m-x86_64-linux-gnu.so cv2.so

# create a sym-link to Python environment
WORKDIR /opt/conda/lib/python3.7/site-packages/
RUN ln -s /usr/local/lib/python3.7/site-packages/cv2/python-3.7/cv2.so cv2.so

# remove non-needed directories
RUN rm -r /opencv.zip && rm -r /opencv_contrib.zip
RUN rm -rf /opencv && rm -rf opencv_contrib

# open up permissions to media (default location for data storage) and mnt (default location for mounted code)
RUN chmod 777 -R /mnt && chmod 777 -R /media

# swith users to default user and working directory to /mnt
WORKDIR /mnt
USER jovyan

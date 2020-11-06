# Start from official jupyter Docker image (https://hub.docker.com/r/jupyter/scipy-notebook)
FROM jvizcar/sage_mp_registration:1.0.0

# install opencv
RUN pip install opencv-python --prefer-binary

# create directories for mounting code and data
USER root
RUN mkdir /code && mkdir /data
RUN chmod 777 -R /code && chmod 777 -R /data

# change the working dir
WORKDIR /code

USER mainuser

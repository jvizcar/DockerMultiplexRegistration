# Starting from Felipe's base jupyter image (https://github.com/fgiuste7/Docker/blob/master/Base/jupyter/Dockerfile)
FROM fgiuste/base:jupyter

# create a user
USER root
RUN useradd -ms /bin/bash mainuser

# swith to new user
USER mainuser


# Update system and install dependencies
RUN apt-get update
RUN apt-get install -y build-essential apt-utils cmake
RUN apt-get install -y git

# Clone SimpleElastix Github repo to /mnt
RUN git clone https://github.com/SuperElastix/SimpleElastix

# /mnt should have full access
RUN chmod 777 -R /mnt/

# Follow instructions for installing SimpleElastix: https://simpleelastix.readthedocs.io/GettingStarted.html
# As mainuser (not sure if this would have been okay to do as root) - compile SimpleElastix
USER mainuser
RUN mkdir build
WORKDIR /mnt/build
RUN cmake ../SimpleElastix/SuperBuild
RUN make -j4

# Install SimpleElastix Python library 
WORKDIR /mnt/build/SimpleITK-build/Wrapping/Python
RUN python Packaging/setup.py install

# As root update conda (fixes error with "Failed Connection" when trying to install Python libraries with conda)
# and install any extra Python libraries
USER root
RUN conda update conda
RUN conda install -y scikit-image

# Switch back to mainuser and set working directory to /mnt
USER mainuser
WORKDIR /mnt/

# Jupyter-notebook at Startup
CMD [ "jupyter-notebook", "--notebook-dir=/mnt/" ]
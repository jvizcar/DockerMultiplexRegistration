# Starting from Felipe's base jupyter image (https://github.com/fgiuste7/Docker/blob/master/Base/jupyter/Dockerfile)
FROM jvizcar/sage_mp_registration:base

# as root install additional packages
USER root

RUN conda install -y -c conda-forge opencv

# switch back to mainuser
USER mainuser


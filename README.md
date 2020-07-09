# Docker Image - jvizcar/sage_mp_registration
2020-07-08

This image contains an installation of SimpleElastix in an Ubuntu 18.04 base image. Other useful packages installed include opencv, scikit-image, jupyter (for running notebook service, which runs on startup by default), and other useful Python tools for image registration.

This Docker image was primarily designed to work in multiplex histology images for the purpose of registering rounds through various methods.

Sample command:

```
$ docker run --rm -it -p<localport>:8888 -v <localDirToMount>:/mnt/<folderNameToMountTo> jvizcar/sage_mp_registration:latest
```

You can also use specific tags instead of latest. Look in this repo for each tags README for information about that tag.

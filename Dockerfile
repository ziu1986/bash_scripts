FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get -yqq install \
      --no-install-recommends \
      ca-certificates \
      cdo \
      g++ \
      gcc \
      gfortran \
      git \
      ksh \
      libblas-dev \
      libeccodes-dev \
      libhdf5-dev \
      liblapack-dev \
      libnetcdf-dev \
      libnetcdff-dev \
      libopenmpi-dev \
      libxml2-dev \
      make \
      perl \
      python3 \
      rsync \
      ssh \
      vim

RUN useradd -ms /bin/bash icon
USER icon
WORKDIR /home/icon

RUN (echo 'export PS1="\[$(tput bold)\]\[$(tput setaf 2)\]\u@\[$(tput setaf 3)\]dev-gcc\[$(tput sgr0)\]:\w$ "') > ~/.bashrc


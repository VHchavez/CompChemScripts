#Rename as "Dockerfile"

FROM ubuntu:16.04

# Install dependencies
RUN  apt update && \
     apt install -yq \
        vim \
        wget \
        openssh-server \
        gfortran \
        make \
        automake \
        m4 \
	libarpack2 \
        libtool \
        libgsl0-dev \
        libblas-dev \
        liblas-dev \
        liblapack-dev \
        libfftw3-dev  \
        curl && \
    apt-get install openmpi-bin libopenmpi-dev --assume-yes && \
    mkdir -p /octo/ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Change working directory
WORKDIR /octo

RUN apt-get install lib64gcc-4.9-dev

# Install Libxc and GSL
RUN mkdir bin && \
    curl -JLO tddft.org/programs/octopus/down.php?file=4.1.2/octopus-4.1.2.tar.gz && \
    curl -JLO http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-2.1.3.tar.gz && \
    curl -JLO http://ftpmirror.gnu.org/gsl/gsl-1.14.tar.gz && \
    tar xvzf octopus-4.1.2.tar.gz && \
    tar xvzf libxc-2.1.3.tar.gz && \
    tar xvzf gsl-1.14.tar.gz && \
    rm octopus-4.1.2.tar.gz libxc-2.1.3.tar.gz gsl-1.14.tar.gz && \
    cd /octo/gsl-1.14 && ./configure --prefix=/octo/bin && make && make install 

 
  #    cd /octo/libxc-2.1.3/m4/ && sed -i '82s/.*/   if test \-z \"\$FCCPP\"\; then FCCPP\=\"\/lib\/cpp -ansi\"\; fi/' acx.m4 && \
RUN cd /octo/libxc-2.1.3 && ./configure --prefix=/octo/bin FC=gfortran F77=gfortran CC=gcc && make && make install

# Install Octopus 
#RUN    cd /octo/octopus-4.1.2 && ./configure CC=mpicc FC=mpif90 --with-arpack=/usr/lib/x86_64-linux-gnu/libarpack.so.2 --with-gsl-prefix=/octo/bin --with-libxc-prefix=/octo/bin     --enable-mpi && make && make install 
RUN    cd /octo/octopus-4.1.2 && FCCPP='/lib/cpp -C' ./configure CC=mpicc FC=mpif90 --with-arpack=/usr/lib/x86_64-linux-gnu/libarpack.so.2 --with-gsl-prefix=/octo/bin --with-libxc-prefix=/octo/bin --enable-mpi && make && make install

#RUN    cd /octo/octopus-4.1.2 && ./configure CC=mpicc FC=mpif90 --with-arpack=/usr/lib/x86_64-linux-gnu/libarpack.so.2 --with-gsl-prefix=/octo/bin --with-libxc-prefix=/octo/bin     --enable-mpi && make && make install && \ 
#    cd /opt/etsf/bin/ && ln -s octopus_mpi octopus


RUN cd && echo "PATH=/octo/bin:/opt/etsf/bin:${PATH}" >> .bashrc

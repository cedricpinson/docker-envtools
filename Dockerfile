FROM ubuntu:14.04.1

MAINTAINER trigrou


RUN apt-get -y update --fix-missing && apt-get install -y \
    p7zip-full \
    ccache \
    cmake \
    g++ \
    git \
    libgif-dev \
    libwebp-dev \
    libpng12-dev \
    libtiff5-dev \
    libjpeg-dev \
    libopenjpeg-dev \
    libboost-dev libboost-filesystem-dev libboost-regex-dev libboost-system-dev libboost-thread-dev \
    software-properties-common \
    python \
    wget

RUN echo "/usr/local/lib64/" >/etc/ld.so.conf.d/lib64.conf
RUN echo "/usr/local/lib/" >/etc/ld.so.conf.d/lib.conf

ENV LD_LIBRARY_PATH /usr/local/lib/:/usr/local/lib64/

RUN wget http://download.savannah.nongnu.org/releases/openexr/ilmbase-2.2.0.tar.gz
RUN tar xvfz ilmbase-2.2.0.tar.gz && cd ilmbase-2.2.0 && ./configure && make -j6 install

RUN wget http://download.savannah.nongnu.org/releases/openexr/openexr-2.2.0.tar.gz
RUN tar xvfz openexr-2.2.0.tar.gz && cd openexr-2.2.0 && ./configure --disable-ilmbasetest && make -j6 install

# openimageio
RUN cd /root/ && wget https://github.com/OpenImageIO/oiio/archive/Release-1.5.9RC1.tar.gz && cd /root/ && tar xvfz Release-1.5.9RC1.tar.gz
RUN cd /root/oiio-Release-1.5.9RC1 && mkdir release && cd release/ && cmake ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER="ccache" -DCMAKE_CXX_COMPILER_ARG1="g++" && make -j6 install


# envtools
RUN cd /root/ && git clone https://github.com/cedricpinson/envtools envtools && mkdir envtools/release && cd /root/envtools/release && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER="ccache" -DCMAKE_CXX_COMPILER_ARG1="g++" ../
RUN cd /root/envtools/release && make -j6 install

RUN rm -r /root/envtools /root/oiio-Release-1.5.9RC1 ilmbase-2.2.0.tar.gz ilmbase-2.2.0 openexr-2.2.0.tar.gz openexr-2.2.0

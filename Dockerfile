FROM codercom/code-server

RUN sudo apt-get -yq update
RUN sudo apt-get -yq upgrade

# Install python env
RUN sudo apt-get install -yq libxml2-dev python3.8-dev \
        && sudo apt-get install -yq python3-pip \
        && sudo ln -s /usr/bin/python3.8 /usr/bin/python \
        && python -m pip install numpy pandas lxml


# Basics packages
RUN sudo apt-get install git wget nano curl apt-transport-https autotools-dev ninja-build automake make libbz2-dev libxml2-dev -yq


# CPP ENV
ENV BOOST_DIR=/boost
ENV BOOST_ROOT=$BOOST_DIR
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BOOST_DIR/lib/

RUN sudo apt purge libboost-dev && wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2 \
    && tar -xvf boost_1_69_0.tar.bz2 \
    && rm boost_1_69_0.tar.bz2 \
    && cd ./boost_1_69_0 \
    && sudo ./bootstrap.sh --prefix=$BOOST_DIR \
    && sudo ./b2 install
RUN rm -rf boost_1_69_0


RUN sudo apt purge cmake -y \
    &&  wget https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5.tar.gz \
    && tar -zxvf cmake-3.14.5.tar.gz \
    && rm cmake-3.14.5.tar.gz \
    && cd ./cmake-3.14.5 && ./bootstrap --prefix=$LOCAL_DIR  \
    && make && sudo make install
RUN rm -rf cmake-3.14.5


# some useful cpp libs
# JSON lib
RUN git clone https://github.com/nlohmann/json.git json  && cd json \
    && mkdir build && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/ && sudo make  && sudo make install


# date lib
ENV date_version=v2.4.1
RUN git clone https://github.com/HowardHinnant/date.git date && cd date \
    &&  git tag -l && git checkout ${date_version} \
    && mkdir build && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/ -DCMAKE_CXX_FLAGS="-fPIC" -DUSE_SYSTEM_TZ_DB=ON -DBUILD_SHARED_LIBS=ON \
    && sudo make && sudo make install

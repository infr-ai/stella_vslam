FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y build-essential git cmake clang-format \
    libboost-all-dev libspdlog-dev libopencv-dev libeigen3-dev libgl1-mesa-dev \
    libyaml-cpp-dev libsuitesparse-dev libsqlite3-dev

WORKDIR /app

# g2o
RUN cd /app && git clone --recursive https://github.com/RainerKuemmerle/g2o.git && cd g2o && git checkout e8df200 && \
    mkdir -p build && cd build && cmake .. && make -j && make install && cd /app
    
# FBoW
RUN cd /app && git clone --recursive https://github.com/stella-cv/FBoW.git && cd FBoW && \
    mkdir -p build && cd build && cmake .. && make -j && make install && cd /app

# stella_vslam
RUN cd /app && mkdir -p /app/stella_vslam && cd /app/stella_vslam
COPY . .
RUN mkdir -p build && cd build && cmake .. && make -j && make install && cd /app

RUN wget https://github.com/stella-cv/FBoW_orb_vocab/raw/main/orb_vocab.fbow -O /app/orb_vocab.fbow
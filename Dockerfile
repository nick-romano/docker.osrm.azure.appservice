FROM ubuntu:16.04
ARG OSM_FILE
ENV OSM_FILE=$OSM_FILE
ARG DOWNLOAD_URL
ENV DOWNLOAD_URL=$DOWNLOAD_URL
RUN echo $DOWNLOAD_URL
RUN echo $OSM_FILE
RUN mkdir -p data
RUN if [ test -z $DOWNLOAD_URL ]; then COPY $OSM_FILE ./data; else apt-get update && apt install -y wget && wget $DOWNLOAD_URL -P ./data; fi;
RUN apt update
RUN apt install -y build-essential git cmake pkg-config \
libbz2-dev libstxxl-dev libstxxl1v5 libxml2-dev \
libzip-dev libboost-all-dev lua5.2 liblua5.2-dev libtbb-dev bzip2 \
libluabind-dev libluabind0.9.1v5  wget supervisor
RUN wget https://github.com/Project-OSRM/osrm-backend/archive/v5.23.0.tar.gz
RUN tar -xzf v5.23.0.tar.gz
WORKDIR ./osrm-backend-5.23.0
RUN mkdir -p build
WORKDIR ./build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_BUILD_TYPE=Debug
RUN cmake --build .
RUN cmake --build . --target install
WORKDIR ../..
RUN mkdir -p network
WORKDIR ./network
RUN mkdir -p data
RUN cp -R ../data ./data
WORKDIR data/data
RUN osrm-extract -p ../../../../osrm-backend-5.23.0/profiles/car.lua $OSM_FILE
RUN osrm-partition $OSM_FILE
RUN osrm-customize $OSM_FILE
RUN apt install -y nodejs
RUN apt install -y npm
COPY package.json .
COPY package-lock.json .
COPY index.js .
RUN npm install
COPY supervisord.conf /etc/supervisord.conf
EXPOSE 3000
EXPOSE 5000
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

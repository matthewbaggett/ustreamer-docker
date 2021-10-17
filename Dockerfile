FROM ubuntu:focal AS build
WORKDIR /build

RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        make \
        gcc \
        git \
        libevent-dev \
        libjpeg8-dev \
        uuid-dev \
        libbsd-dev
#        libraspberrypi-dev \
#        wiringpi

RUN git clone --depth=1 https://github.com/pikvm/ustreamer

WORKDIR /build/ustreamer/
RUN make 

FROM ubuntu:focal AS run
RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        libevent-2.1 \
        libevent-pthreads-2.1-6 \
        libjpeg8 \
        uuid \
        libbsd0 

WORKDIR /ustreamer
COPY --from=build /build/ustreamer/ustreamer .

EXPOSE 8080
ENTRYPOINT [ "./ustreamer", "--host=0.0.0.0", "--slowdown"]

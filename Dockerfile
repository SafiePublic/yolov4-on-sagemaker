from nvidia/cuda:10.0-cudnn7-devel

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y --no-install-recommends \
  git \
  build-essential \
  libopencv-dev \
  python3 \
  wget \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Darknetをコンパイル
RUN cd /opt \
&& git clone https://github.com/AlexeyAB/darknet.git \
&& cd darknet \
&& sed -i \
  -e 's/GPU=./GPU=1/'\
  -e 's/CUDNN=./CUDNN=1/' \
  -e 's/CUDNN_HALF=./CUDNN_HAL=1/' \
  -e 's/OPENCV=./OPENCV=1/'\
  Makefile \
&& make -j$(nproc)

# pretainedモデルをダウンロード
RUN mkdir -p /opt/darknet/weights \
&& cd /opt/darknet/weights \
&& wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137

COPY main.py /opt/darknet/
WORKDIR /opt/darknet
ENTRYPOINT ["python3", "main.py"]


FROM python:3.9-buster

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl \
    git


WORKDIR /app
ADD ./requirements.txt /app
RUN python3.9 -m pip install --upgrade pip
RUN pip install -r requirements.txt --use-pep517
RUN python3.9 -m pip install -U memory_profiler
ENTRYPOINT ["python3.9", "-u", "run_algorithm.py"]
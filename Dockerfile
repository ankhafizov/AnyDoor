FROM python:3.10.13

WORKDIR /usr/src/app

RUN pip install --upgrade pip
RUN apt-get -y update && apt-get -y upgrade && apt-get install -y --no-install-recommends ffmpeg


# Install Miniconda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN arch=$(uname -m) && \
    if [ "$arch" = "x86_64" ]; then \
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"; \
    elif [ "$arch" = "aarch64" ]; then \
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"; \
    else \
    echo "Unsupported architecture: $arch"; \
    exit 1; \
    fi && \
    wget $MINICONDA_URL -O miniconda.sh && \
    mkdir -p /root/.conda && \
    bash miniconda.sh -b -p /root/miniconda3 && \
    rm -f miniconda.sh

COPY . .

RUN conda env create -f environment.yaml

ENV PATH /opt/conda/envs/myconda/bin:$PATH
ENV CONDA_DEFAULT_ENV myconda

## MAKE ALL BELOW RUN COMMANDS USE THE NEW CONDA ENVIRONMENT
RUN echo "conda activate myconda" >> ~/.bashrc
# RUN conda activate anydoor

ENTRYPOINT ["python", "run_gradio_demo.py"] 
# ENTRYPOINT ["tail", "-f", "/dev/null"]
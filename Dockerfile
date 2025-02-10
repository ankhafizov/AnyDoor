FROM continuumio/miniconda3

WORKDIR /usr/src/app

RUN apt-get -y update && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends ffmpeg \ 
    && apt-get install libgl1

# Create the environment:
COPY . .
RUN conda env create -f environment.yaml

SHELL ["conda", "run", "-n", "anydoor", "/bin/bash", "-c"]

ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "anydoor", "python", "run_gradio_demo.py"]


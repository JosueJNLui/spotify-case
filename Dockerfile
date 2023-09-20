FROM python:3.8-slim-buster

RUN mkdir -p /home/notebooks
WORKDIR /home/notebooks

RUN pip install numpy \
                pandas \
                seaborn \
                matplotlib \
                jupyter \
                notebook

EXPOSE 8888 

ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", \
"--no-browser"]
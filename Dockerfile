# Use the official Python 3.8 image as the base image.
FROM python:3.8-slim-buster

# Create a directory '/home/notebooks' inside the container.
RUN mkdir -p /home/notebooks

# Set the working directory to '/home/notebooks' inside the container.
WORKDIR /home/notebooks

# Install Python libraries and Jupyter Notebook.
RUN pip install numpy \
                pandas \
                seaborn \
                matplotlib \
                jupyter \
                notebook \
                requests

# Expose port 8888 from the container to allow external access.
#EXPOSE 8888

# Define the command to execute when the container starts.
#ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser"]
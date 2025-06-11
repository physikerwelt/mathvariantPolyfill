# Start with an official Jupyter Notebook base image
FROM jupyter/base-notebook

# Install Java (required for BaseX)
USER root
RUN apt-get update && apt-get install -y basex

# Install Python dependencies (requests, pandas, lxml, etc.)
RUN pip install --no-cache-dir pandas requests lxml

# Set up the working directory to be your current notebook folder
WORKDIR /home/jovyan/work

# Start a bash shell to allow interaction with the container
CMD ["start.sh", "jupyter", "notebook", "--NotebookApp.token=''"]

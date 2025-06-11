# Start with an official Jupyter Notebook base image
FROM jupyter/base-notebook

# Install Java (required for BaseX)
USER root
RUN apt-get update && apt-get install -y openjdk-11-jre-headless wget

# Install BaseX
RUN wget https://basex.org/files/BaseX9.5.zip && \
    unzip BaseX9.5.zip && \
    mv BaseX9.5 /opt/basex && \
    rm BaseX9.5.zip

# Set environment variables for BaseX
ENV PATH="/opt/basex/bin:$PATH"
ENV BASEx_HOME="/opt/basex"

# Install Python dependencies (requests, pandas, lxml, etc.)
RUN pip install --no-cache-dir pandas requests lxml

# Set up the working directory to be your current notebook folder
WORKDIR /home/jovyan/work

# Expose the necessary port for BaseX
EXPOSE 1984

# Start a bash shell to allow interaction with the container
CMD ["start.sh", "jupyter", "notebook", "--NotebookApp.token=''"]

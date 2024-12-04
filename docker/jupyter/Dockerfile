# Use Ubuntu as the base image
FROM public.ecr.aws/docker/library/debian:bookworm

ARG USERNAME=jupyter
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG PYTHON_VERSION=3.13

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash
ENV CONDA_ENV=jupyter
ENV HOME=/home/$USERNAME

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # Add sudo support.
    && apt-get update \
    && apt-get install -y sudo curl git vim gettext tmux build-essential libssl-dev libffi-dev procps \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && chsh -s /bin/bash $USERNAME \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install NodeJS
RUN curl -fsSL https://deb.nodesource.com/setup_23.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch to the new user
USER $USERNAME

SHELL ["/bin/bash", "-lec"]

# Install Miniconda
RUN curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh \
    && bash ~/miniconda.sh -b -p $HOME/miniconda \
    && rm ~/miniconda.sh \
    && $HOME/miniconda/bin/conda init bash \
    && echo "source $HOME/miniconda/etc/profile.d/conda.sh" >> ~/.shellrc-local \
    && echo "conda activate $CONDA_ENV" >> ~/.shellrc-local
    
ENV PATH=$HOME/miniconda/bin:$PATH

# Create a Conda environment and install Python libraries
RUN source $HOME/miniconda/etc/profile.d/conda.sh \
    && conda update -n base -c defaults conda \
    && conda create -y -n $CONDA_ENV python=$PYTHON_VERSION \
    && conda activate $CONDA_ENV \
    && conda install -y -c conda-forge "jupyterlab>=4.1.0,<5.0.0a0" \
    && conda clean --all

# Set working directory
WORKDIR $HOME/workspace

# Expose the Jupyter Notebook default port
EXPOSE 8888

# Add settings and entrypoint
RUN mkdir -p $HOME/.jupyter/lab/user-settings/
COPY user-settings/* $HOME/.jupyter/lab/user-settings/
COPY entrypoint.sh /entrypoint.sh

RUN sudo chmod +x /entrypoint.sh

CMD ["bash", "-lc", "/entrypoint.sh"]

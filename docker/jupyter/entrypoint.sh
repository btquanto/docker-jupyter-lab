if [ ! -z "$APP_TOKEN" ]; then
    APP_TOKEN=""
fi
if [ ! -z "$APP_PASSWORD" ]; then
    APP_PASSWORD=""
fi

source $HOME/miniconda/etc/profile.d/conda.sh;
conda activate $CONDA_ENV;


if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/primestyle-co/dotfiles;
    python dotfiles/install.py;
fi

if [ ! -f "$HOME/.cache/.setup" ]; then
    # First time setup
    cd $HOME;

    # Install jupyter lab extensions
    conda install -y -c conda-forge \
                        jupyterlab-spreadsheet-editor \
                        jupyterlab-git jupyterlab-lsp \
                        jupyterlab-latex \
                        ipywidgets black isort openpyxl python-lsp-server;
    pip install jupyterlab-code-formatter \
                pandas numpy matplotlib seaborn scikit-learn pillow arxiv \
                boto3 pymysql;

    # Create .setup file to avoid re-running the setup again
    mkdir -p $HOME/.cache/ && touch $HOME/.cache/.setup;
fi

jupyter lab --ip=0.0.0.0 --port=8888 --no-browser \
            --NotebookApp.token=$APP_TOKEN --NotebookApp.password=$APP_PASSWORD;
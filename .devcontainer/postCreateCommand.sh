/julia-devcontainer-scripts/postcreate.jl
sudo apt-get update && sudo apt-get install -y --no-install-recommends python3-pip
pip3 install --upgrade pip && pip3 install pre-commit
pre-commit install

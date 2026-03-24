#!/bin/bash 
sudo apt-get install -y libosmocore-dev
git clone https://gitea.osmocom.org/tetra/osmo-tetra
cd osmo-tetra/src/
make
sudo cp ./tetra-rx /usr/local/bin
cd ../..
rm -rf osmo-tetra
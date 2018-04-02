#!/bin/sh
wget https://releases.hashicorp.com/terraform/0.11.5/terraform_0.11.5_linux_amd64.zip

unzip terraform_0.11.5_linux_amd64.zip

# move the folder to the executable path
sudo mv terraform /usr/local/bin/

# clean up an install files from the project
rm terraform_0.11.5_linux_amd64.zip

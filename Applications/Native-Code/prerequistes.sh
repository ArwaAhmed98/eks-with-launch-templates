#!/bin/bash

# Update the system packages
sudo yum update -y

# Install Python 3 and pip
sudo yum install -y python3

# Verify Python and pip installation
python3 --version
pip3 --version

# Upgrade pip to the latest version
pip3 install --upgrade pip

# Install Flask and redis libraries
pip3 install flask redis

# Verify Flask and redis installation
pip3 show flask redis

# Print completion message
echo "Python, Flask, and Redis have been installed successfully!"

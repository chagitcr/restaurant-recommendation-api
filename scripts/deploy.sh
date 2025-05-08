#!/bin/bash

# Create a temporary directory for packaging
mkdir -p build
cd build

# Create a virtual environment and install dependencies
python3 -m venv venv
source venv/bin/activate
pip install -r ../src/lambda/requirements.txt

# Create deployment package
mkdir -p package
pip install --target ./package -r ../src/lambda/requirements.txt
cp ../src/lambda/app.py ./package/

# Create ZIP file
cd package
zip -r ../function.zip .
cd ..

# Move ZIP file to lambda directory
mv function.zip ../src/lambda/

# Clean up
cd ..
rm -rf build

echo "Deployment package created at src/lambda/function.zip" 
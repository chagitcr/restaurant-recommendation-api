#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first:"
    echo "  pip install awscli"
    exit 1
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is not installed. Please install it first."
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install requirements
echo "Installing requirements..."
pip install -r requirements.txt

# Set the DynamoDB table name
export DYNAMODB_TABLE_NAME="restaurant-recommendation-dev"

echo "Seeding DynamoDB table: $DYNAMODB_TABLE_NAME"

# Run the seed script
python seed_data.py

# Deactivate virtual environment
deactivate

echo "Done!" 
#!/bin/bash

# Create AWS credentials directory if it doesn't exist
mkdir -p ~/.aws

# Function to check if AWS CLI is installed
check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI is not installed. Please install it first:"
        echo "  pip install awscli"
        exit 1
    fi
}

# Function to configure AWS credentials
configure_aws() {
    echo "Setting up AWS credentials..."
    
    # Prompt for AWS credentials
    read -p "Enter your AWS Access Key ID: " aws_access_key
    read -p "Enter your AWS Secret Access Key: " aws_secret_key
    read -p "Enter your AWS Region [us-west-2]: " aws_region
    aws_region=${aws_region:-us-west-2}

    # Create credentials file
    cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id = ${aws_access_key}
aws_secret_access_key = ${aws_secret_key}
EOF

    # Create config file
    cat > ~/.aws/config << EOF
[default]
region = ${aws_region}
output = json
EOF

    # Set proper permissions
    chmod 600 ~/.aws/credentials
    chmod 600 ~/.aws/config

    echo "AWS credentials have been configured successfully!"
    echo "You can now run 'aws sts get-caller-identity' to verify your credentials."
}

# Main execution
check_aws_cli
configure_aws 
# Restaurant Recommendation API

A serverless API that provides restaurant recommendations based on user preferences. Built with AWS Lambda, API Gateway, and DynamoDB.

## Prerequisites

- AWS CLI installed and configured with appropriate credentials
- Python 3.9 or later
- Terraform 1.0 or later

## Project Structure

```
.
├── src/
│   └── lambda/
│       ├── app.py
│       └── requirements.txt
├── config/
│   └── terraform/
│       ├── environments/
│       │   └── prod/
│       │       ├── main.tf
│       │       ├── variables.tf
│       │       └── dev.tfvars
│       └── modules/
│           ├── api_gateway/
│           ├── dynamodb/
│           ├── kms/
│           └── lambda/
├── scripts/
│   ├── seed_data.py
│   ├── seed_dynamodb.sh
│   └── setup_aws.sh
├── docs/
│   ├── architecture.md
│   ├── api.md
│   └── development.md
├── README.md
└── requirements.txt
```

## Setup Instructions

### 1. AWS Setup

1. Make the AWS setup script executable:
```bash
chmod +x scripts/setup_aws.sh
```

2. Run the AWS setup script:
```bash
./scripts/setup_aws.sh
```

The script will:
- Configure AWS CLI with your credentials
- Set up the default region
- Create necessary AWS resources
- Configure environment variables

### 2. Lambda Function Deployment

1. Make the deploy script executable:
```bash
chmod +x scripts/deploy.sh
```

2. Run the deploy script to create the Lambda deployment package:
```bash
./scripts/deploy.sh
```

The script will:
- Create a temporary build directory
- Set up a clean virtual environment
- Install dependencies
- Create a deployment package
- Generate the Lambda function ZIP file
- Clean up temporary files

### 3. Terraform Deployment

1. Initialize Terraform:
```bash
cd config/terraform/environments/prod
terraform init
```

2. Review the planned changes:
```bash
terraform plan -var-file=dev.tfvars
```

3. Apply the configuration:
```bash
terraform apply -var-file=dev.tfvars
```

4. Save the outputs for later use:
```bash
terraform output > terraform_outputs.txt
```

### 4. Seeding DynamoDB

1. Make the seed script executable:
```bash
chmod +x scripts/seed_dynamodb.sh
```

2. Change to the scripts directory and run the seed script (use the table name from Terraform outputs):
```bash
TABLE_NAME="restaurant-recommendation-dev" ./seed_dynamodb.sh
```

### 5. Testing the API

1. Get the API endpoint from Terraform outputs:
```bash
API_ENDPOINT=$(terraform output -raw api_endpoint)
```

2. Test the API with curl:
```bash
curl -X GET "${API_ENDPOINT}?style=Italian&vegetarian=yes"
```

## Scripts Overview

### 1. `setup_aws.sh`
- Purpose: Sets up AWS environment and configurations
- Features:
  - Configures AWS CLI credentials
  - Sets up default region
  - Creates necessary AWS resources
  - Configures environment variables
- Usage:
  ```bash
  ./scripts/setup_aws.sh
  ```

### 2. `deploy.sh`
- Purpose: Creates the Lambda function deployment package
- Features:
  - Creates a temporary build environment
  - Sets up a clean virtual environment
  - Installs dependencies
  - Creates a deployment ZIP file
  - Handles cleanup
- Usage:
  ```bash
  ./scripts/deploy.sh
  ```

### 3. `seed_data.py`
- Purpose: Seeds the DynamoDB table with sample restaurant data
- Usage: Called by `seed_dynamodb.sh`
- Features:
  - Uses Decimal type for numeric values
  - Handles DynamoDB batch writing
  - Provides progress feedback

### 4. `seed_dynamodb.sh`
- Purpose: Sets up environment and runs the seed script
- Features:
  - Checks for AWS CLI and Python installation
  - Creates and activates virtual environment
  - Installs required packages
  - Runs the seed script with proper table name
- Usage:
  ```bash
  TABLE_NAME="your-table-name" ./scripts/seed_dynamodb.sh
  ```

## API Usage

### Endpoints

1. Get Restaurant Recommendations
```
GET /recommendations
```

Query Parameters:
- `style` (optional): Cuisine style (e.g., "Italian", "Japanese")
- `vegetarian` (optional): "true" or "false"
- `location` (optional): Area name (e.g., "Downtown")
- `delivery` (optional): "true" or "false"
- `open_now` (optional): "true" or "false"

Example Request:
```bash
curl -X GET "https://<api-id>.execute-api.<region>.amazonaws.com/dev/recommendations?style=Italian&vegetarian=yes"
```

### Example Response
```json
{
  "recommendations": [
    {
      "vegetarian": "true",
      "openHour": "09:00",
      "closeHour": "20:00",
      "address": "321 Elm St, City",
      "delivery": "true",
      "id": "b1bc637e-5b6e-4e41-896d-37b45ffde8a7",
      "name": "Taco Fiesta",
      "style": "Mexican"
    }
  ]
}
```

## Future Improvements

### 1. CI/CD Pipeline
- Add automatic Lambda packaging on code changes
- Implement infrastructure drift detection
- Add automated security scanning

### 2. State Management
- Implement state storage in DynamoDB for user preferences

### 3. Custom Domain Setup
- Add ACM (AWS Certificate Manager) for SSL/TLS
- Configure Route 53 hosted zone
- Create DNS records for the API Gateway
- Set up custom domain mapping in API Gateway

### 4. Security Enhancements
- Implement API key rotation
- Add rate limiting
- Set up WAF (Web Application Firewall)
- Implement request validation
- Add input sanitization

## Troubleshooting

### Common Issues

1. Lambda Deployment Issues
- Ensure the ZIP file is created correctly using `deploy.sh`
- Check Lambda function permissions
- Verify environment variables

2. API Gateway Issues
- Check API Gateway logs in CloudWatch
- Verify Lambda integration
- Check API Gateway permissions

3. DynamoDB Issues
- Verify table permissions
- Check data format
- Ensure proper indexing

4. KMS Issues
- Verify KMS key permissions
- Check CloudWatch Logs encryption settings
- Ensure Lambda has proper KMS permissions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Documentation

### Architecture
- [Architecture](docs/architecture.md)

### API
- [API](docs/api.md)


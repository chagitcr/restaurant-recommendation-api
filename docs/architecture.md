# Architecture

## Overview
The Restaurant Recommendation API is built using a serverless architecture on AWS, consisting of the following components:

### Components
1. **API Gateway**
   - HTTP API type
   - Handles routing and request/response transformation
   - Integrated with Lambda function

2. **Lambda Function**
   - Python 3.10 runtime
   - Handles business logic
   - Interacts with DynamoDB

3. **DynamoDB**
   - NoSQL database
   - Stores restaurant data

4. **KMS**
   - Manages encryption keys
   - Used for CloudWatch logs encryption

### Data Flow
1. Client sends request to API Gateway
2. API Gateway routes request to Lambda
3. Lambda processes request and queries DynamoDB
4. Response flows back through API Gateway to client

### Security
- KMS encryption for logs
- IAM roles and policies
- API Gateway authorization
- DynamoDB encryption at rest 

# Serverless Event Registration & Ticketing System

A serverless event registration and ticketing system built on AWS. The application allows users to browse available events, register for an event, view their registrations, and cancel registrations.

The project demonstrates the use of AWS serverless services, Infrastructure as Code with Terraform, automated deployment with GitHub Actions, and centralized monitoring with Amazon CloudWatch.

---

## 📌 Project Overview

The **Event Registration & Ticketing System** provides a simple web-based interface where users can:

- View available events
- Register for an event
- Receive a registration and ticket ID
- View their registrations using their email address
- Cancel an existing registration

The application uses a serverless architecture, meaning there are no servers to manage manually. AWS Lambda handles the application logic, Amazon DynamoDB stores application data, and Amazon S3 hosts the frontend.

Infrastructure is provisioned using **Terraform**, while **GitHub Actions** automates validation, infrastructure deployment, Lambda packaging, and frontend deployment.

---

## 🎯 Project Objectives

The main objectives of this project are to:

1. Build a serverless web application using AWS.
2. Implement REST APIs using Amazon API Gateway.
3. Develop backend business logic using AWS Lambda.
4. Store events and registrations using Amazon DynamoDB.
5. Host the frontend using Amazon S3.
6. Implement logging and monitoring using Amazon CloudWatch.
7. Manage AWS infrastructure using Terraform.
8. Implement CI/CD using GitHub Actions.
9. Apply appropriate IAM permissions between AWS services.
10. Demonstrate practical cloud architecture and deployment concepts.

---

# 🏗️ Architecture

## Application Architecture

The application follows this flow:

```text
                           USER
                             │
                             │ HTTPS
                             ▼
                    ┌─────────────────┐
                    │   Amazon S3     │
                    │ Static Website  │
                    │ HTML/CSS/JS     │
                    └────────┬────────┘
                             │
                             │ API Requests
                             ▼
                    ┌─────────────────┐
                    │ API Gateway     │
                    │ REST API        │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
        GET /events    POST /register   GET /registrations/{email}
              │              │              │
              ▼              ▼              ▼
        ┌─────────┐    ┌──────────┐   ┌───────────────┐
        │ Lambda  │    │  Lambda  │   │    Lambda     │
        │GetEvents│   │ Register │   │GetRegistrations│
        └────┬────┘    └────┬─────┘   └───────┬───────┘
             │              │                 │
             └──────────────┼─────────────────┘
                            │
                            ▼
                    ┌─────────────────┐
                    │   DynamoDB      │
                    │                 │
                    │ Events          │
                    │ Registrations   │
                    └─────────────────┘

                 DELETE /delete-registration/{id}
                            │
                            ▼
                       AWS Lambda
                            │
                            ▼
                       DynamoDB

                            │
                            ▼
                    Amazon CloudWatch
                    Logs • Metrics • Alarms

Architecture Diagram

The architecture diagram illustrates both the application request flowand the development/deployment workflow.

☁️ AWS Services Used

AWS ServicePurpose

Amazon S3            Hosts the static frontend websiteAmazon API Gateway   Provides REST API endpointsAWS Lambda           Runs serverless backend business logicAmazon DynamoDB      Stores events and registrationsAmazon CloudWatch    Provides logging and monitoringAWS IAM              Controls permissions between AWS servicesTerraform            Provisions and manages AWS infrastructureGitHub Actions       Automates CI/CD

🔌 API Endpoints

The application exposes the following REST API endpoints:

MethodEndpointDescription

GET                       /events                     Retrieve all available events

POST                      /register                   Register a user for an event

GET                       /registrations/{email}      Retrieve registrations for anemail address

DELETE                    /delete-registration/{id}   Cancel a registration

API Base URL

The API is deployed through Amazon API Gateway using the developmentstage:

https://<api-id>.execute-api.us-east-1.amazonaws.com/dev

Example:

GET /events

https://<api-id>.execute-api.us-east-1.amazonaws.com/dev/events

🖥️ Frontend

The frontend is a lightweight HTML, CSS, and JavaScript applicationhosted on Amazon S3.

The frontend provides:

Home page

Available events page

Event registration form

My Registrations page

Registration cancellation

API integration using JavaScript

Responsive and simple user interface

Frontend Technologies

HTML5

CSS3

JavaScript

Fetch API

⚙️ Backend

The backend is completely serverless.

Each API operation is handled by a dedicated AWS Lambda function.

Lambda Functions

src/
├── get_events/
│   └── lambda_function.py
│
├── register_event/
│   └── lambda_function.py
│
├── get_registrations/
│   └── lambda_function.py
│
└── delete_registration/
    └── lambda_function.py

The Lambda functions are responsible for:

Processing API Gateway requests

Validating request data

Performing DynamoDB operations

Handling errors

Logging important application events

Returning consistent API responses

🗄️ DynamoDB

The application uses two DynamoDB tables.

Events Table

Stores information about available events.

Example structure:

event_id
name
description
date
location

The event_id uniquely identifies each event.

Registrations Table

Stores user registrations.

Example structure:

registration_id
ticket_id
event_id
full_name
email
status
registered_at

The registration ID and ticket ID are generated when a user successfullyregisters.

🎟️ Registration Flow

When a user registers for an event:

User
 │
 ▼
Registration Form
 │
 ▼
POST /register
 │
 ▼
API Gateway
 │
 ▼
Register Event Lambda
 │
 ├── Validate request
 ├── Validate required fields
 ├── Validate email
 ├── Verify event exists
 ├── Check duplicate registration
 ├── Generate registration ID
 ├── Generate ticket ID
 └── Store registration
        │
        ▼
   DynamoDB
        │
        ▼
 Success Response

Example successful response:

{
  "success": true,
  "message": "Registration successful.",
  "data": {
    "registration_id": "REG-XXXXXXXX",
    "ticket_id": "TKT-XXXXXXXX",
    "event_id": "EVT-001",
    "status": "CONFIRMED"
  }
}

❌ Error Handling

The application implements structured error handling for commonscenarios.

Examples include:

Invalid request

400 Bad Request

Event not found

404 Not Found

Duplicate registration

409 Conflict

Database/server errors

500 Internal Server Error

The Lambda functions use Python exception handling and CloudWatchlogging to help identify application and infrastructure problems.

📊 Monitoring & Logging

Amazon CloudWatch is used to monitor the Lambda functions.

The application records useful information such as:

GET /events invoked
Retrieved events
POST /register invoked
Registration created successfully
Database operation failed
Unexpected server error

CloudWatch provides:

Lambda logs

Execution information

Error tracking

Metrics

Troubleshooting information

This makes it possible to investigate application failures withoutmanually accessing a server.

🏗️ Infrastructure as Code

The AWS infrastructure is managed using Terraform.

Instead of manually creating AWS resources through the AWS Console,Terraform defines the infrastructure as code.

Example:

terraform/
├── provider.tf
├── versions.tf
├── backend.tf
├── variables.tf
├── terraform.tfvars
├── locals.tf
├── outputs.tf
├── iam.tf
├── lambda.tf
├── dynamodb.tf
├── apigateway.tf
├── cloudwatch.tf
├── s3.tf
├── website.tf
└── budgets.tf

Terraform is responsible for provisioning and managing resources suchas:

API Gateway

Lambda functions

DynamoDB tables

S3 bucket

IAM roles and policies

CloudWatch log groups

API Gateway deployment and stage

🔄 CI/CD Pipeline

The project uses GitHub Actions to automate deployment.

The deployment workflow follows:

Developer
    │
    │ git push
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Terraform Format
    ├── Terraform Validate
    ├── Terraform Plan
    ├── Terraform Apply
    ├── Build & Package Lambda Functions
    └── Deploy Frontend to S3
    │
    ▼
AWS Infrastructure

This reduces manual deployment steps and ensures that infrastructurechanges can be consistently applied.

🔐 Security

Security is implemented using AWS IAM and controlled servicepermissions.

The project uses:

IAM roles for Lambda execution

IAM policies with required permissions

API Gateway access configuration

S3 access configuration

GitHub repository secrets for CI/CD credentials

Environment variables for resource configuration

Sensitive credentials and secrets are not stored directly in the sourcecode.

🌐 CORS

Cross-Origin Resource Sharing (CORS) is configured to allow the frontendhosted on Amazon S3 to communicate with the API Gateway REST API.

This allows browser-based JavaScript requests such as:

S3 Frontend
     │
     │ fetch()
     ▼
API Gateway

without the browser blocking the request because it originates from adifferent domain.

📁 Project Structure

event-registration-ticketing-system/
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── frontend/
│   ├── css/
│   │   └── styles.css
│   │
│   ├── js/
│   │   ├── api.js
│   │   ├── config.js
│   │   ├── events.js
│   │   ├── register.js
│   │   └── registrations.js
│   │
│   ├── index.html
│   ├── register.html
│   ├── registrations.html
│   └── events.html
│
├── src/
│   ├── common/
│   │   ├── logger.py
│   │   ├── responses.py
│   │   ├── ticket.py
│   │   ├── utils.py
│   │   └── validation.py
│   │
│   ├── get_events/
│   │   └── lambda_function.py
│   │
│   ├── register_event/
│   │   └── lambda_function.py
│   │
│   ├── get_registrations/
│   │   └── lambda_function.py
│   │
│   └── delete_registration/
│       └── lambda_function.py
│
├── terraform/
│   ├── provider.tf
│   ├── versions.tf
│   ├── backend.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── locals.tf
│   ├── outputs.tf
│   ├── iam.tf
│   ├── lambda.tf
│   ├── dynamodb.tf
│   ├── apigateway.tf
│   ├── cloudwatch.tf
│   ├── s3.tf
│   ├── website.tf
│   └── budgets.tf
│
├── build/
│   └── Lambda deployment packages
│
├── architecture.png
├── .gitignore
└── README.md

🚀 Deployment

Prerequisites

AWS account

AWS CLI

Terraform

Git

Python

GitHub repository

Appropriate AWS IAM permissions

The project uses the AWS region:

us-east-1

1. Clone the Repository

git clone <repository-url>
cd event-registration-ticketing-system

2. Configure AWS Credentials

aws configure

3. Initialize Terraform

cd terraform
terraform init

4. Format Terraform

terraform fmt -recursive

5. Validate Configuration

terraform validate

6. Review the Deployment Plan

terraform plan

7. Deploy Infrastructure

terraform apply

🧪 Testing

The application can be tested using Postman, a browser, the deployedfrontend, and Lambda test events.

User journey

Home
  ↓
Events
  ↓
Select Event
  ↓
Register
  ↓
View Registration
  ↓
Cancel Registration

🛠️ Troubleshooting

502 Bad Gateway

A 502 Bad Gateway can occur when Lambda fails during execution orreturns an invalid response expected by API Gateway.

Check:

Lambda
  ↓
Monitor
  ↓
CloudWatch Logs

CORS Error

If the browser reports a CORS error:

Verify CORS configuration.

Confirm the API URL.

Confirm the frontend uses the correct API endpoint.

Redeploy the API Gateway stage if necessary.

Missing Authentication Token

Verify that the requested path and HTTP method match an existing APIGateway route.

For example:

POST /register

rather than:

POST /registration

💰 Cost Considerations

The project uses primarily serverless AWS services:

AWS Lambda

API Gateway

DynamoDB

S3

CloudWatch

Actual charges depend on usage, AWS pricing, and applicable Free Tiereligibility. AWS usage and billing should be monitored duringdevelopment and testing.

🔮 Future Improvements

The current implementation focuses on the core event registration andticketing functionality.

Amazon CloudFront

CloudFront could be placed in front of the S3 frontend:

User
 │
 ▼
CloudFront
 │
 ▼
Amazon S3

Potential benefits:

Global content delivery

Improved website performance

HTTPS support

Edge caching

Reduced latency

Amazon SNS

SNS could be integrated into the registration workflow:

User Registration
       │
       ▼
AWS Lambda
       │
       ▼
Amazon SNS
       │
       ├── Registration notification
       └── Event notification

Potential use cases:

Registration confirmation notifications

Event update notifications

Administrative alerts

Event Capacity / Limited Availability

The application can indicate when an event or program has limitedcapacity. A future frontend enhancement could display:

Available Seats: 25

and when capacity is reached:

Event Full
Registration Closed

📈 Future Architecture

                         USER
                           │
                           ▼
                     CloudFront
                           │
                           ▼
                      Amazon S3
                           │
                           ▼
                    API Gateway
                           │
                           ▼
                    AWS Lambda
                     /        \
                    /          \
                   ▼            ▼
              DynamoDB       Amazon SNS
                 │               │
                 ▼               ▼
            CloudWatch      Notifications

CloudFront and SNS are documented as future improvements and are notpart of the current deployed architecture.

🎓 Key AWS Concepts Demonstrated

Serverless architecture

REST APIs

Amazon API Gateway

AWS Lambda

Amazon DynamoDB

Amazon S3 static website hosting

AWS IAM

Amazon CloudWatch

CORS

Infrastructure as Code

Terraform

Terraform state management

Git and GitHub

GitHub Actions

CI/CD

Error handling

API response formatting

DynamoDB data modelling

Lambda event handling

Cloud monitoring and troubleshooting
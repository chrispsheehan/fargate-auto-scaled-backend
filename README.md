# fargate-auto-scaled-backend

New image pushed to ecr upon changes detected in `/src` and subsequently deployed to ecs.

## deployment


## usage

- obtain `url` from terraform outputs
- `curl [url]/dev/host`
  - example response below
```sh
{
    "message":"Request handled by backend at 2024-09-25T12:28:17.593Z",
    "imageUri":"700011111111.dkr.ecr.eu-west-2.amazonaws.com/fargate-auto-scaled-backend@sha256:78dfc01946306dd6afea2b47b56e196788501bfa93c1b2ee1e90a54e72b56938",
    "hostname":"ip-10-55-161-195.eu-west-2.compute.internal"
}
```

## docker

```sh
docker build -t express-app .
docker run -i -p 3000:3000 express-app
```

## terraform

Required deployment iam privileges.

```json
[
    "dynamodb:*", 
    "s3:*", 
    "ecr:*", 
    "iam:*", 
    "ecs:*",
    "ec2:*", 
    "elasticloadbalancing:*",
    "application-autoscaling:*",
    "logs:*",
    "sqs:*",
    "cloudwatch:*",
    "apigateway:*"
]
```

## ci

Commits to `main` will kick off a deployment.

Required github action variables.
- `AWS_ACCOUNT_ID`
- `AWS_REGION`
- `AWS_ROLE` role with deployment privileges
- `DOCKERHUB_USERNAME`

Required github action secrets.
- `DOCKERHUB_PASSWORD`
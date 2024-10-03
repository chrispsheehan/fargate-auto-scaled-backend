# fargate-auto-scaled-backend

A load balanced and auto-scaled api running on AWS ECS.

## ci

`Init` workflow

1. Query AWS for existing service - do not run if found.
2. Create ECR repository.
3. Push a new *initial* image to ecr.
4. Create a new task definition is created.
5. The new task definition is deployed to the ecs service.
6. The *blue* target group is deployed as the default.

*note* this cannot be run after a Deploy workflow [tech debt]

`Deploy` workflow

1. Check ECR repository is found.
2. New image is pushed to ecr upon changes detected in `/src`, `Dockerfile` or `package.json`.
3. Subsequently a new task definition is created.
4. Codedeploy deployment is created and status is monitored.
5. New *green* target group and containers created. When health traffic is switched over to them.

`Destroy` workflow

1. Destroy all deployed resources.
2. Destroy ECR repository.

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
    "cloudwatch:*",
    "apigateway:*",
    "codedeploy:*"
]
```

## ci config

Required github action variables.
- `AWS_ACCOUNT_ID`
- `AWS_REGION`
- `AWS_ROLE` role with above deployment privileges

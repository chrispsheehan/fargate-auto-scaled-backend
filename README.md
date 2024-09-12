# fargate-auto-scaled-backend

New image pushed to ecr upon changes detected in `/src` and subsequently deployed to ecs.

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
    "logs:*"
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
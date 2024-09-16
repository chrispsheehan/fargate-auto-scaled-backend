format:
    #!/usr/bin/env bash
    cd tf
    terraform fmt --recursive

check:
    #!/usr/bin/env bash
    cd tf
    terraform validate

init:
    #!/usr/bin/env bash
    cd tf
    terraform init

local-deploy:
    #!/usr/bin/env bash
    REPONAME=fargate-auto-scaled-backend
    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    AWS_REGION=eu-west-2
    aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
    IMAGE_TAG=$(aws ecr describe-images --repository-name $REPONAME --region "$AWS_REGION" --query 'sort_by(imageDetails,&imagePushedAt)[-1].imageTags[0]' --output text)
    IMAGE_URI="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPONAME:$IMAGE_TAG"
    echo $IMAGE_URI
    cd tf
    terraform init
    terraform apply
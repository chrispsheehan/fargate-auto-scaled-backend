format:
    #!/usr/bin/env bash
    cd tf
    terraform fmt --recursive

check:
    #!/usr/bin/env bash
    cd tf
    terraform validate

local-deploy:
    #!/usr/bin/env bash
    DOCKERHUB_USERNAME=chrispsheehan
    DOCKERHUB_REPONAME=fargate-auto-scaled-backend
    IMAGE_TAG=$(curl -s "https://hub.docker.com/v2/repositories/$DOCKERHUB_USERNAME/$DOCKERHUB_REPONAME/tags/?page_size=1&ordering=last_updated" | jq -r '.results[0].name')
    IMAGE_URI="docker.io/$DOCKERHUB_USERNAME/$DOCKERHUB_REPONAME:$IMAGE_TAG"
    export TF_VAR_image_uri=$IMAGE_URI
    cd tf
    terraform init
    terraform apply
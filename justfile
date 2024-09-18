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
    cd tf
    terraform init
    terraform apply

local-destroy:
    #!/usr/bin/env bash
    cd tf
    terraform init
    terraform destroy
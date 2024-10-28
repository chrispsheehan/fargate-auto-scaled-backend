format:
    #!/usr/bin/env bash
    cd tf
    terraform fmt --recursive

validate:
    #!/usr/bin/env bash
    for dir in tf/*; do
        if [ -d "$dir" ]; then
            echo "Validating $dir"
            cd "$dir"
            terraform init
            terraform validate
            cd - > /dev/null
        fi
    done

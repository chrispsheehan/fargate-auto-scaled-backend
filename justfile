format:
    #!/usr/bin/env bash
    cd tf
    terraform fmt --recursive

check:
    #!/usr/bin/env bash
    cd tf
    terraform validate
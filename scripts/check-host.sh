#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <ssh-host>"
    exit 1
fi

SSH_HOST="$1"

echo "=== Health check for $SSH_HOST ==="
ssh ${NIX_SSHOPTS:-} "$SSH_HOST" bash <<'EOF'
  echo "Status: online"
  echo "Current generation: $(readlink /run/current-system)"
EOF

#!/usr/bin/env bash
# Idempotent Cloud Agent install for the bayesian-optimization library.
# Ensures uv (the pinned package manager + build backend) is available, then
# syncs the project's virtual environment with the dev extra.
set -euo pipefail

# Resolve the repository root from this script's own location so the uv
# commands always run where pyproject.toml lives, regardless of the caller's
# working directory.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# 1. Ensure uv is installed. The official installer places uv in
#    $HOME/.local/bin and wires it into the shell profile, so this is safe to
#    re-run: it is skipped once uv is present.
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
export PATH="$HOME/.local/bin:$PATH"

uv --version

# 2. Create/refresh the .venv with runtime + dev dependencies. `uv sync` is
#    idempotent: a second run resolves against the lockfile and installs
#    nothing new.
uv sync --extra dev

echo "install.sh complete: bayesian-optimization dev environment is ready in $REPO_ROOT"

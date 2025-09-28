#!/bin/bash

# Script to build the Debian build environment Docker image and start a container
# with a specified directory mounted as /workspace.
#
# Usage: ./run.sh <directory_path>
# Example: ./run.sh /path/to/my/project
#
# If no directory is provided, it defaults to the current directory (.) .

set -e  # Exit on any error

IMAGE_NAME="debian-build-env"

# default workspace directory if not provided
WORKSPACE_DIR="${1:-.}"

# check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH." >&2
    exit 1
fi

# check if the provided directory exists
if [[ ! -d "$WORKSPACE_DIR" ]]; then
    echo "Error: Directory '$WORKSPACE_DIR' does not exist." >&2
    exit 1
fi

echo "Building Docker image '$IMAGE_NAME'..."
docker build -t "$IMAGE_NAME" .

echo "Starting container with '$WORKSPACE_DIR' mounted to /workspace..."
echo "You can now build your apps inside the container. Exit the shell to stop."
docker run -it --rm \
    -v "$WORKSPACE_DIR:/workspace" \
    -w /workspace \
    "$IMAGE_NAME"

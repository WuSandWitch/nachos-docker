#!/bin/bash

# NachOS Docker Run Script
# Launches interactive NachOS environment

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Starting NachOS Interactive Environment ===${NC}"
echo -e "${YELLOW}Platform: x86_64 emulated on ARM${NC}"
echo ""
echo -e "${GREEN}You will be dropped into the NachOS/code directory${NC}"
echo -e "${GREEN}Example commands to try:${NC}"
echo "  make                    # Build NachOS"
echo "  ./userprog/nachos -e ./test/test1    # Run test1"
echo "  ./userprog/nachos -d +  # Run with debug output"
echo "  exit                    # Exit container"
echo ""
echo -e "${YELLOW}Starting container...${NC}"

# Run container with volume mount for development
docker run \
    --platform linux/amd64 \
    -it \
    --rm \
    -v "$(pwd)":/work \
    nachos:arm-to-x86
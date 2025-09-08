#!/bin/bash

# NachOS Docker Build Script for ARM Architecture (Apple Silicon M2)
# This script builds and runs NachOS in a Docker container with x86_64 emulation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== NachOS Docker Build Script for ARM Architecture ===${NC}"
echo -e "${YELLOW}Target: Apple Silicon M2 ARM -> x86_64 emulation${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed or not in PATH${NC}"
    echo "Please install Docker Desktop for Mac first"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker daemon is not running${NC}"
    echo "Please start Docker Desktop"
    exit 1
fi

# Build Docker image
echo -e "${YELLOW}Building NachOS Docker image for x86_64 platform...${NC}"
echo "This may take several minutes on first build..."
echo ""

docker build --platform linux/amd64 -t nachos:arm-to-x86 .

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Docker image built successfully!${NC}"
else
    echo -e "${RED}❌ Docker build failed${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}=== Build Complete ===${NC}"
echo -e "${GREEN}Image name: nachos:arm-to-x86${NC}"
echo -e "${GREEN}Platform: linux/amd64 (emulated on ARM)${NC}"
echo ""
echo -e "${YELLOW}Available commands:${NC}"
echo "  ./run.sh          - Run interactive NachOS environment"
echo "  ./test.sh         - Run basic NachOS tests"
echo ""
echo -e "${YELLOW}Manual Docker commands:${NC}"
echo "  docker run --platform linux/amd64 -it --rm nachos:arm-to-x86"
echo "  docker run --platform linux/amd64 -it --rm -v \$(pwd):/work nachos:arm-to-x86"
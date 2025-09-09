#!/bin/bash

# NachOS Docker Installation Script
# Cross-platform Docker Environment for NachOS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DOCKER_IMAGE="nachos:optimized"

echo -e "${BLUE}🚀 NachOS Docker Installation${NC}"
echo -e "${CYAN}Cross-platform NachOS development environment${NC}"
echo ""

# Function to check command existence
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}Error: $1 is not installed or not in PATH${NC}"
        return 1
    fi
    return 0
}

# Check prerequisites
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

if ! check_command docker; then
    echo "Please install Docker first:"
    echo "- macOS: https://docs.docker.com/desktop/mac/install/"
    echo "- Linux: https://docs.docker.com/engine/install/"
    echo "- Windows: https://docs.docker.com/desktop/windows/install/"
    exit 1
fi

if ! check_command git; then
    echo "Please install Git first:"
    echo "- All platforms: https://git-scm.com/downloads"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker daemon is not running${NC}"
    echo "Please start Docker:"
    echo "- macOS/Windows: Start Docker Desktop"
    echo "- Linux: sudo systemctl start docker"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites satisfied${NC}"
echo ""

# Check available disk space (at least 2GB)
echo -e "${YELLOW}📊 Checking available disk space...${NC}"
available_space=$(df -H . | awk 'NR==2 {print $4}' | sed 's/G.*//')
if [ "$available_space" -lt 2 ]; then
    echo -e "${YELLOW}Warning: Less than 2GB available disk space${NC}"
    echo "NachOS environment requires approximately 1GB"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✅ Sufficient disk space available${NC}"
fi
echo ""

# Build Docker image
echo -e "${YELLOW}🔨 Building NachOS Docker image (this may take 5-10 minutes)...${NC}"
docker build --platform linux/amd64 -t "$DOCKER_IMAGE" .

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ NachOS Docker image built successfully${NC}"
else
    echo -e "${RED}❌ Docker build failed${NC}"
    exit 1
fi

echo ""

# Run basic tests
echo -e "${YELLOW}🧪 Running basic functionality tests...${NC}"
./test.sh

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ All tests passed${NC}"
else
    echo -e "${RED}❌ Tests failed${NC}"
    exit 1
fi

echo ""


# Installation complete
echo ""
echo -e "${BLUE}🎉 ==========================${NC}"
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo -e "${BLUE}=========================== 🎉${NC}"
echo ""
echo -e "${CYAN}📍 Current Directory: $(pwd)${NC}"
echo -e "${CYAN}🚀 Docker Image: $DOCKER_IMAGE${NC}"
echo ""
echo -e "${YELLOW}🔧 Available Commands:${NC}"
echo -e "  ./run.sh          # Start interactive NachOS environment"
echo -e "  ./test.sh         # Run functionality tests"
echo ""
echo -e "${YELLOW}💡 Quick Start:${NC}"
echo -e "  ./run.sh"
echo ""
echo -e "${GREEN}🎓 Ready for NachOS development on any platform!${NC}"
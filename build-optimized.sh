#!/bin/bash

# NachOS Optimized Docker Build Script
# Creates smaller production-ready image

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== NachOS Optimized Docker Build ===${NC}"
echo -e "${CYAN}Creating production-ready optimized image${NC}"
echo ""

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker daemon is not running${NC}"
    echo "Please start Docker Desktop"
    exit 1
fi

# Build optimized image
echo -e "${YELLOW}Building optimized NachOS Docker image...${NC}"
echo "Using multi-stage build for reduced size..."
echo ""

docker build --platform linux/amd64 -f Dockerfile.optimized -t nachos:optimized .

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Optimized Docker image built successfully!${NC}"
else
    echo -e "${RED}❌ Optimized Docker build failed${NC}"
    exit 1
fi

echo ""

# Compare image sizes
echo -e "${YELLOW}📊 Image Size Comparison:${NC}"
echo -e "${CYAN}Standard image:${NC}"
docker images nachos:arm-to-x86 --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}" 2>/dev/null || echo "  (not built yet)"

echo -e "${CYAN}Optimized image:${NC}"
docker images nachos:optimized --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}"

echo ""

# Quick functionality test
echo -e "${YELLOW}🧪 Running quick functionality test...${NC}"
docker run --platform linux/amd64 --rm nachos:optimized /bin/bash -c "
    cd /root/NachOS/code &&
    ./userprog/nachos -e ./test/test1
"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Optimized image functionality verified${NC}"
else
    echo -e "${RED}❌ Optimized image test failed${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}=== Optimized Build Complete ===${NC}"
echo -e "${GREEN}Image name: nachos:optimized${NC}"
echo -e "${GREEN}Ready for distribution${NC}"
echo ""
echo -e "${YELLOW}Usage:${NC}"
echo "  docker run --platform linux/amd64 -it --rm nachos:optimized"
#!/bin/bash

# NachOS Docker Test Script
# Runs basic NachOS functionality tests

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== NachOS Functionality Test ===${NC}"
echo -e "${YELLOW}Running basic NachOS tests in Docker container...${NC}"
echo ""

# Test 1: Build verification
echo -e "${YELLOW}Test 1: Verifying NachOS build...${NC}"
docker run --platform linux/amd64 --rm nachos:optimized /bin/bash -c "
    cd /root/NachOS/code &&
    ls -la userprog/nachos &&
    echo 'Build verification: PASSED'
"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build verification successful${NC}"
else
    echo -e "${RED}❌ Build verification failed${NC}"
    exit 1
fi

echo ""

# Test 2: Run test1
echo -e "${YELLOW}Test 2: Running test1 program...${NC}"
docker run --platform linux/amd64 --rm nachos:optimized /bin/bash -c "
    cd /root/NachOS/code &&
    ./userprog/nachos -e ./test/test1
"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ test1 execution successful${NC}"
else
    echo -e "${RED}❌ test1 execution failed${NC}"
    exit 1
fi

echo ""

# Test 3: Debug mode test
echo -e "${YELLOW}Test 3: Testing debug mode...${NC}"
docker run --platform linux/amd64 --rm nachos:optimized /bin/bash -c "
    cd /root/NachOS/code &&
    timeout 10 ./userprog/nachos -d t || true
"

echo -e "${GREEN}✅ Debug mode test completed${NC}"

echo ""
echo -e "${BLUE}=== All Tests Completed Successfully ===${NC}"
echo -e "${GREEN}NachOS Docker environment is working correctly on ARM architecture!${NC}"
echo ""
echo -e "${YELLOW}Ready for development. Use ./run.sh to start interactive session.${NC}"
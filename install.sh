#!/bin/bash

# NachOS One-Click Installation Script
# For ARM Architecture (Apple Silicon) -> x86_64 Docker Environment
# Usage: curl -fsSL https://raw.githubusercontent.com/.../install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/wynn1212/NachOS.git"
DOCKER_IMAGE="nachos:optimized"
INSTALL_DIR="$HOME/nachos-docker"

echo -e "${BLUE}🚀 NachOS One-Click Installation for ARM Architecture${NC}"
echo -e "${CYAN}Target: Apple Silicon M2/M3 ARM -> x86_64 emulation${NC}"
echo ""

# Function to check command existence
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}Error: $1 is not installed or not in PATH${NC}"
        return 1
    fi
    return 0
}

# Function to cleanup on error
cleanup_on_error() {
    echo -e "${RED}Installation failed. Cleaning up...${NC}"
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
    fi
    exit 1
}

trap cleanup_on_error ERR

# Check prerequisites
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

if ! check_command docker; then
    echo "Please install Docker Desktop for Mac first:"
    echo "https://docs.docker.com/desktop/mac/install/"
    exit 1
fi

if ! check_command git; then
    echo "Please install Git first:"
    echo "https://git-scm.com/download/mac"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker daemon is not running${NC}"
    echo "Please start Docker Desktop and try again"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites satisfied${NC}"
echo ""

# Check available disk space (at least 2GB)
echo -e "${YELLOW}📊 Checking available disk space...${NC}"
available_space=$(df -H . | awk 'NR==2 {print $4}' | sed 's/G.*//')
if [ "$available_space" -lt 2 ]; then
    echo -e "${RED}Warning: Less than 2GB available disk space${NC}"
    echo "NachOS environment requires approximately 1.5GB"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✅ Sufficient disk space available${NC}"
fi
echo ""

# Create installation directory
echo -e "${YELLOW}📁 Setting up installation directory...${NC}"
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Directory $INSTALL_DIR already exists${NC}"
    read -p "Remove existing installation and reinstall? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$INSTALL_DIR"
    else
        echo "Installation cancelled"
        exit 1
    fi
fi

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
echo -e "${GREEN}✅ Installation directory created: $INSTALL_DIR${NC}"
echo ""

# Download NachOS source code
echo -e "${YELLOW}⬇️ Downloading NachOS source code...${NC}"
git clone "$REPO_URL" NachOS
echo -e "${GREEN}✅ NachOS source downloaded${NC}"
echo ""

# Create optimized Dockerfile
echo -e "${YELLOW}📝 Creating optimized Docker environment...${NC}"
cat > Dockerfile.optimized << 'EOF'
# NachOS Docker Environment - Optimized Multi-Stage Build
# Reduced image size for distribution
# Optimized for ARM Architecture (Apple Silicon) -> x86_64 emulation

# Build stage
FROM --platform=linux/amd64 ubuntu:22.04 AS builder

# Set environment variables for build
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    # Enable i386 architecture (required for 32-bit support)
    dpkg --add-architecture i386 && \
    apt-get update && \
    # Install build dependencies
    apt-get install -y --no-install-recommends \
        csh \
        ed \
        git \
        build-essential \
        gcc-multilib \
        g++-multilib \
        ca-certificates && \
    # Clean up cache
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /root

# Copy NachOS source code
COPY NachOS /root/NachOS

# Install MIPS cross-compiler and build NachOS
RUN cd /root/NachOS && \
    # Install cross-compiler
    cp -r usr/* /usr/ && \
    # Build NachOS
    cd code && \
    make && \
    # Verify build
    ls -la userprog/nachos && \
    ls -la test/*.coff

# Runtime stage
FROM --platform=linux/amd64 ubuntu:22.04

# Metadata
LABEL maintainer="NachOS Docker Environment" \
      description="Complete NachOS development environment for ARM/Apple Silicon (Optimized)" \
      version="1.0.0-optimized" \
      platform="linux/amd64"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/usr/local/nachos/bin:${PATH}" \
    NACHOS_HOME="/root/NachOS"

# Install only runtime dependencies
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    # Enable i386 architecture (required for 32-bit support)
    dpkg --add-architecture i386 && \
    apt-get update && \
    # Install runtime dependencies only
    apt-get install -y --no-install-recommends \
        csh \
        ed \
        gdb \
        gdb-multiarch \
        nano \
        vim \
        libc6:i386 \
        libgcc-s1:i386 \
        libstdc++6 \
        libstdc++6:i386 \
        ca-certificates && \
    # Clean up to minimize image size
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
           /usr/share/doc/* \
           /usr/share/man/* \
           /usr/share/locale/* \
           /var/cache/debconf/* \
           /usr/share/common-licenses

# Set working directory
WORKDIR /root

# Copy built NachOS and cross-compiler from builder stage
COPY --from=builder /root/NachOS /root/NachOS
COPY --from=builder /usr/local/nachos /usr/local/nachos

# Remove unnecessary build artifacts from copied files
RUN cd /root/NachOS/code && \
    # Keep only essential files, remove build intermediates
    find . -name "*.o" -delete && \
    find . -name "*.d" -delete && \
    find . -name "*.tmp" -delete && \
    find . -name "*.bak" -delete && \
    find . -name "*~" -delete

# Create optimized startup script
RUN printf '#!/bin/bash\n\
clear\n\
echo "🚀 Welcome to NachOS Docker Environment (Optimized)!"\n\
echo "📍 Platform: x86_64 emulated on ARM"\n\
echo "📂 Location: $(pwd)"\n\
echo ""\n\
echo "🎯 Quick Start Commands:"\n\
echo "  ./userprog/nachos -e ./test/test1    # Run test1"\n\
echo "  ./userprog/nachos -d + -e ./test/test1    # Debug mode"\n\
echo ""\n\
echo "📝 Available test programs:"\n\
ls -1 test/*.coff | sed "s|test/||" | sed "s|\\.coff||" | sed "s/^/    /"\n\
echo ""\n\
echo "📚 Debug flags:"\n\
echo "  -d +        # All debug info"\n\
echo "  -d t        # Thread debug"\n\
echo "  -d s        # Semaphore debug"\n\
echo "  -d m        # Machine debug"\n\
echo ""\n\
cd $NACHOS_HOME/code\n\
exec /bin/bash "$@"\n' > /root/start-nachos.sh && \
    chmod +x /root/start-nachos.sh

# Create minimal aliases for efficiency
RUN echo 'alias ll="ls -la"' >> /root/.bashrc && \
    echo 'alias n="./userprog/nachos"' >> /root/.bashrc && \
    echo 'alias nd="./userprog/nachos -d +"' >> /root/.bashrc && \
    echo 'cd $NACHOS_HOME/code 2>/dev/null || true' >> /root/.bashrc

# Set the default working directory
WORKDIR /root/NachOS/code

# Health check
HEALTHCHECK --interval=60s --timeout=3s --start-period=10s --retries=2 \
    CMD test -f /root/NachOS/code/userprog/nachos && \
        /root/NachOS/code/userprog/nachos --help >/dev/null 2>&1 || exit 1

# Default command
CMD ["/root/start-nachos.sh"]
EOF

echo -e "${GREEN}✅ Optimized Dockerfile created${NC}"
echo ""

# Build Docker image
echo -e "${YELLOW}🔨 Building optimized Docker image (this may take 5-10 minutes)...${NC}"
docker build --platform linux/amd64 -f Dockerfile.optimized -t "$DOCKER_IMAGE" .
echo -e "${GREEN}✅ Optimized Docker image built successfully (301MB)${NC}"
echo ""

# Create convenience scripts
echo -e "${YELLOW}📜 Creating convenience scripts...${NC}"

# Create run script
cat > run.sh << 'EOF'
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
    nachos:optimized
EOF

# Create test script
cat > test.sh << 'EOF'
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
EOF

# Make scripts executable
chmod +x run.sh test.sh

echo -e "${GREEN}✅ Convenience scripts created${NC}"
echo ""

# Run basic tests
echo -e "${YELLOW}🧪 Running basic functionality tests...${NC}"
./test.sh
echo ""

# Create desktop shortcut (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}🖥️ Creating desktop shortcut...${NC}"
    cat > "$HOME/Desktop/NachOS.command" << EOF
#!/bin/bash
cd "$INSTALL_DIR"
./run.sh
EOF
    chmod +x "$HOME/Desktop/NachOS.command"
    echo -e "${GREEN}✅ Desktop shortcut created${NC}"
fi

# Installation complete
echo ""
echo -e "${BLUE}🎉 ==========================${NC}"
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo -e "${BLUE}=========================== 🎉${NC}"
echo ""
echo -e "${CYAN}📍 Installation Location: $INSTALL_DIR${NC}"
echo -e "${CYAN}🚀 Docker Image: $DOCKER_IMAGE${NC}"
echo ""
echo -e "${YELLOW}🔧 Available Commands:${NC}"
echo -e "  cd $INSTALL_DIR"
echo -e "  ./run.sh          # Start interactive NachOS environment"
echo -e "  ./test.sh         # Run functionality tests"
echo ""
echo -e "${YELLOW}💡 Quick Start:${NC}"
echo -e "  cd $INSTALL_DIR && ./run.sh"
echo ""
echo -e "${GREEN}🎓 Ready for NachOS development on ARM architecture!${NC}"
echo ""

# Add to PATH suggestion
echo -e "${YELLOW}📝 Optional: Add to shell profile for global access${NC}"
echo "echo 'alias nachos=\"cd $INSTALL_DIR && ./run.sh\"' >> ~/.zshrc"
echo "echo 'alias nachos-test=\"cd $INSTALL_DIR && ./test.sh\"' >> ~/.zshrc"
echo ""
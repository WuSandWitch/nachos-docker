# NachOS Docker Environment for ARM Architecture (Apple Silicon M2)
# This Dockerfile creates a Ubuntu x86_64 environment that runs on ARM via emulation

FROM --platform=linux/amd64 ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/local/nachos/bin:${PATH}"

# Set working directory
WORKDIR /root

# Update system and install dependencies
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    # Enable i386 architecture (required for 32-bit support)
    dpkg --add-architecture i386 && \
    apt-get update && \
    # Install NachOS dependencies as specified in the tutorial
    apt-get install -y \
        csh \
        ed \
        git \
        build-essential \
        gcc-multilib \
        g++-multilib \
        gdb \
        gdb-multiarch \
        nano \
        vim \
        wget \
        curl && \
    # Clean up to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy NachOS source code
COPY NachOS /root/NachOS

# Install MIPS cross-compiler from the provided usr directory
RUN cd /root/NachOS && \
    cp -r usr/* /usr/ && \
    # Verify cross-compiler installation
    ls -la /usr/local/nachos/bin/ || echo "Cross-compiler path may be different"

# Build NachOS
WORKDIR /root/NachOS/code
RUN make clean || true && \
    make

# Create convenient aliases and setup
RUN echo 'alias ll="ls -la"' >> /root/.bashrc && \
    echo 'alias nachos="./userprog/nachos"' >> /root/.bashrc && \
    echo 'cd /root/NachOS/code' >> /root/.bashrc && \
    echo 'echo "=== NachOS Docker Environment Ready ==="' >> /root/.bashrc && \
    echo 'echo "Current directory: $(pwd)"' >> /root/.bashrc && \
    echo 'echo "Available test programs in ./test/"' >> /root/.bashrc && \
    echo 'echo "Example: ./userprog/nachos -e ./test/test1"' >> /root/.bashrc

# Set the default working directory to NachOS code
WORKDIR /root/NachOS/code

# Default command
CMD ["/bin/bash"]
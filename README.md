# NachOS Docker Environment for ARM Architecture

This project provides a Docker-based solution to run NachOS (Not Another Completely Heuristic Operating System) on ARM architecture, specifically designed for Apple Silicon M2 chips.

## 🎯 Problem Solved

- **Architecture Compatibility**: Runs x86_64 NachOS on ARM architecture through Docker emulation
- **Environment Consistency**: Provides the exact Ubuntu 22.04 LTS environment as specified in the course
- **Easy Setup**: One-command installation and execution
- **Course Compliance**: Includes all dependencies and MIPS cross-compiler from the course materials

## 📋 Prerequisites

- Docker Desktop for Mac (with Apple Silicon support)
- Git
- At least 4GB of available disk space

## 🚀 Quick Start

1. **Clone and Install**:
   ```bash
   git clone git@github.com:WuSandWitch/nachos-docker.git
   cd nachos-docker
   ./install.sh
   ```

2. **Start Interactive Development**:
   ```bash
   ./run.sh
   ```

3. **Test the Environment**:
   ```bash
   ./test.sh
   ```

## 📁 Project Structure

```
nachos-docker/
├── Dockerfile          # Docker container definition
├── build.sh            # Build script for the environment
├── run.sh              # Launch interactive environment
├── test.sh             # Run basic functionality tests
├── README.md           # This file
└── NachOS/             # Course-provided NachOS source code
    ├── code/           # Main NachOS source
    ├── usr/            # MIPS cross-compiler tools
    └── ...
```

## 💻 Usage Examples

### In the Docker Environment

Once you run `./run.sh`, you'll be in the NachOS development environment:

```bash
# Build NachOS (if needed)
make

# Run test programs
./userprog/nachos -e ./test/test1

# Run with debug output
./userprog/nachos -d + -e ./test/test1

# Run specific debug flags (threads)
./userprog/nachos -d t -e ./test/test1

# Create and test your own programs
cd test/
nano myprogram.c
# Add your program to Makefile
make
cd ..
./userprog/nachos -e ./test/myprogram
```

## 🛠 Development Workflow

1. **Edit Code**: Use your favorite editor on the host machine
2. **Build & Test**: Use the Docker environment for compilation and testing
3. **Version Control**: Git operations work normally on the host

### File Sharing

The `run.sh` script mounts the current directory into the container at `/work`, allowing you to:
- Edit files on your host machine with your preferred tools
- Build and run inside the container
- Maintain persistent changes

## 🔧 Technical Details

### Architecture Emulation

- **Host**: ARM64 (Apple Silicon M2)
- **Container**: linux/amd64 (emulated via Rosetta 2)
- **Performance**: Excellent for development and coursework

### Course Compliance

This environment replicates the exact setup described in the course tutorial:
- Ubuntu 22.04 LTS x86_64
- All required dependencies (`csh`, `ed`, `git`, `build-essential`, etc.)
- MIPS cross-compiler from the course-provided `usr/` directory
- 32-bit support via `i386` architecture enablement

### Container Features

- **Optimized Build**: Multi-stage build process for smaller image size
- **Development Tools**: Includes `nano`, `vim`, `gdb` for debugging
- **Convenient Aliases**: Pre-configured shortcuts for common commands
- **Auto-setup**: Automatically navigates to the correct directory

## 🐛 Troubleshooting

### Docker Issues

```bash
# If Docker daemon is not running
open -a Docker

# If platform issues occur
docker system prune
./build.sh
```

### Build Issues

```bash
# Clean rebuild
docker image rm nachos:arm-to-x86
./build.sh
```

### Performance Issues

The emulation performance is generally excellent, but for intensive development:
- Close unnecessary applications
- Ensure Docker Desktop has adequate resources allocated

## 📚 Course Integration

This setup is designed to work seamlessly with the NachOS course materials:

- **Homework Assignments**: All functionality preserved
- **System Calls**: Full implementation support
- **Debugging**: Complete debug flag support
- **Testing**: All test programs included and working

## 🤝 Contributing

Feel free to improve this setup! Common areas for enhancement:
- Additional development tools
- IDE integration
- Performance optimizations
- Additional test scripts

## 📄 License

This Docker environment setup is provided as-is for educational purposes. NachOS itself retains its original licensing.
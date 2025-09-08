# NachOS Docker Distribution Guide

Complete NachOS development environment for ARM architecture (Apple Silicon) with one-click installation.

## 🚀 Quick Installation

Copy and paste these commands into your terminal:

```bash
git clone git@github.com:WuSandWitch/nachos-docker.git
cd nachos-docker
./install.sh
```

**That's it!** The installation script will:
- ✅ Check prerequisites (Docker, Git)
- ✅ Download NachOS source code
- ✅ Build optimized Docker environment (301MB)
- ✅ Create convenience scripts
- ✅ Run functionality tests
- ✅ Create desktop shortcut (macOS)

## 📋 Prerequisites

- **Docker Desktop for Mac** (with Apple Silicon support)
- **Git** (usually pre-installed on macOS)
- **At least 2GB free disk space**

## 🎯 Quick Start After Installation

```bash
# Navigate to installation directory
cd ~/nachos-docker

# Start interactive NachOS environment
./run.sh

# Inside the container:
./userprog/nachos -e ./test/test1    # Run test1
./userprog/nachos -d + -e ./test/test1    # Debug mode
make                                 # Rebuild if needed
exit                                # Exit container
```

## 🛠 Manual Installation (Alternative)

If you prefer manual installation:

```bash
# Clone repository
git clone https://github.com/YOUR-USERNAME/nachos-docker.git
cd nachos-docker

# Make scripts executable
chmod +x *.sh

# Build environment
./build-optimized.sh

# Test functionality
./test.sh

# Start development
./run.sh
```

## 📊 Image Comparison

| Version | Size | Use Case |
|---------|------|----------|
| Standard (`nachos:arm-to-x86`) | 704MB | Development with all tools |
| Optimized (`nachos:optimized`) | 301MB | **Distribution/Production** |

## 🔧 Available Commands

After installation, you have these convenient commands:

```bash
# In your terminal (host machine):
./run.sh          # Start interactive NachOS environment
./test.sh         # Run functionality tests
./build-optimized.sh  # Rebuild optimized image

# Inside the Docker container:
./userprog/nachos -e ./test/[program]  # Run a program
./userprog/nachos -d + -e ./test/[program]  # Debug mode
make              # Rebuild NachOS
nano test/myprogram.c  # Edit source files
```

## 📝 Creating Your Own Programs

Inside the NachOS environment:

```bash
# Create a new program
nano test/myprogram.c

# Example program content:
#include "syscall.h"
int main() {
    PrintInt(999);
    return 0;
}

# Compile using MIPS cross-compiler:
cd test
/usr/local/nachos/decstation-ultrix/bin/gcc -G 0 -c -I../userprog -I../threads -I../lib myprogram.c
/usr/local/nachos/decstation-ultrix/bin/ld -T script -N start.o myprogram.o -o myprogram.coff
../bin/coff2noff myprogram.coff myprogram

# Run your program:
cd ..
./userprog/nachos -e ./test/myprogram
```

## 🐛 Troubleshooting

### Docker Not Running
```bash
# Start Docker Desktop
open -a Docker
# Wait for Docker to start, then retry installation
```

### Permission Issues
```bash
# Make scripts executable
chmod +x *.sh
```

### Build Issues
```bash
# Clean rebuild
docker image rm nachos:optimized
./build-optimized.sh
```

### Disk Space Issues
```bash
# Clean up Docker
docker system prune -a
# Remove old images
docker images | grep nachos | awk '{print $3}' | xargs docker rmi
```

## 🎓 Course Integration

This environment provides:
- ✅ **Full NachOS 4.0** with all assignments
- ✅ **MIPS cross-compiler** for program compilation
- ✅ **Debug support** with all debug flags (-d +, -d t, -d s, etc.)
- ✅ **Test programs** included (test1, halt, shell, sort, matmult)
- ✅ **Development tools** (nano, vim, gdb)
- ✅ **ARM compatibility** via Docker emulation

## 🔗 Advanced Usage

### Development Workflow
1. **Edit files** on host machine (persistent across container restarts)
2. **Build & test** inside Docker container
3. **Use Git** normally on host machine

### Docker Commands (Manual)
```bash
# Run container manually
docker run --platform linux/amd64 -it --rm nachos:optimized

# Run with volume mount for development
docker run --platform linux/amd64 -it --rm -v "$(pwd)":/work nachos:optimized

# Check image info
docker images nachos:optimized
docker inspect nachos:optimized
```

## 📚 Debug Flags Reference

| Flag | Description | Example |
|------|-------------|---------|
| `-d +` | All debug info | `./userprog/nachos -d + -e ./test/test1` |
| `-d t` | Thread debug | `./userprog/nachos -d t -e ./test/test1` |
| `-d s` | Semaphore debug | `./userprog/nachos -d s -e ./test/test1` |
| `-d m` | Machine debug | `./userprog/nachos -d m -e ./test/test1` |

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Verify Docker Desktop is running
3. Ensure you have sufficient disk space (2GB+)
4. Try rebuilding with `./build-optimized.sh`

## 📄 License

This Docker environment setup is provided for educational purposes. NachOS itself retains its original licensing.

---

**🎉 Ready for NachOS development on ARM architecture!**
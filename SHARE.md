# 🚀 NachOS for ARM Architecture (One-Click Install)

Complete NachOS development environment for Apple Silicon M2/M3 with Docker.

## ⚡ Quick Installation

**Copy and paste these commands:**

```bash
git clone git@github.com:WuSandWitch/nachos-docker.git
cd nachos-docker
./install.sh
```

**Done!** 🎉 The script will automatically:
- ✅ Set up optimized NachOS Docker environment (301MB)
- ✅ Download all required components
- ✅ Test functionality
- ✅ Create desktop shortcut

## 🎯 Quick Start

After installation:
```bash
cd ~/nachos-docker
./run.sh
```

Inside the container:
```bash
./userprog/nachos -e ./test/test1    # Run test1
./userprog/nachos -d + -e ./test/test1    # Debug mode
```

## 📋 Requirements
- Docker Desktop for Mac
- At least 2GB free space

---

**Perfect for NachOS coursework on Apple Silicon! 🍎**
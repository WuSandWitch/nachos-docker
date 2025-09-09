# NachOS Docker Environment | NachOS Docker 開發環境

Complete NachOS development environment with Docker for all platforms.  
跨平台的完整 NachOS Docker 開發環境。

## 🚀 Quick Installation | 快速安裝

**English:**
```bash
git clone git@github.com:WuSandWitch/nachos-docker.git
cd nachos-docker
./install.sh
```

**中文：**
```bash
git clone git@github.com:WuSandWitch/nachos-docker.git
cd nachos-docker
./install.sh
```

That's it! The script will automatically set up everything you need.  
就這樣！安裝腳本會自動設置你需要的一切。

## 🎯 Quick Start | 快速開始

**Start development environment | 啟動開發環境:**
```bash
./run.sh
```

**Inside the container | 在容器內:**
```bash
# Run test program | 執行測試程式
./userprog/nachos -e ./test/test1

# Debug mode | 除錯模式
./userprog/nachos -d + -e ./test/test1

# Rebuild NachOS | 重新建置 NachOS
make clean && make

# Exit container | 離開容器
exit
```

## 📋 Prerequisites | 系統需求

- **Docker** (Docker Desktop or Docker Engine)
- **Git**
- **At least 2GB free space | 至少 2GB 可用空間**

**Supported platforms | 支援平台:**
- macOS (Intel & Apple Silicon)
- Linux (x86_64 & ARM64)
- Windows (with WSL2)

## ✨ Features | 特色

- ✅ **Complete NachOS 4.0 | 完整 NachOS 4.0 環境**
- ✅ **Cross-platform compatibility | 跨平台相容性**
- ✅ **MIPS cross-compiler | MIPS 交叉編譯器**
- ✅ **All test programs included | 包含所有測試程式**
- ✅ **Debug support | 完整除錯支援**
- ✅ **Development tools (nano, vim, gdb) | 開發工具**

## 🔧 Development Workflow | 開發流程

**English:**
1. **Edit code** - Modify files in `/code` directory
2. **Rebuild** - Run `make` to compile changes  
3. **Test** - Run your programs with `./userprog/nachos`

**中文：**
1. **編輯程式碼** - 修改 `/code` 目錄中的檔案
2. **重新建置** - 執行 `make` 編譯修改
3. **測試** - 用 `./userprog/nachos` 執行程式

## 🐛 Troubleshooting | 故障排除

**Docker not running | Docker 未啟動:**
```bash
# macOS
open -a Docker

# Linux
sudo systemctl start docker

# Windows
# Start Docker Desktop from Start Menu
```

**Test functionality | 測試功能:**
```bash
./test.sh
```

**Clean rebuild | 清潔重建:**
```bash
# Inside container | 在容器內
make clean && make
```

## 📚 Common Commands | 常用指令

```bash
# Development | 開發
./run.sh                    # Start environment | 啟動環境
./test.sh                   # Run tests | 執行測試

# Inside container | 容器內指令
make                        # Build NachOS | 建置 NachOS
./userprog/nachos -e ./test/test1    # Run program | 執行程式
./userprog/nachos -d + -e ./test/test1    # Debug mode | 除錯模式
```

## 🎓 Perfect for Coursework | 完美適用於課程作業

This environment provides everything needed for NachOS assignments and projects.  
此環境提供 NachOS 作業和專案所需的一切工具。

---

**Ready for NachOS development on any platform! | 準備在任何平台上開發 NachOS！** ✨
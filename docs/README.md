# 📚 Documentation

Welcome to the AuraPay documentation! This folder contains all technical documentation, guides, and troubleshooting resources.

## 📁 Folder Structure

```
docs/
├── README.md                           # This file - Documentation index
├── README_VI.md                        # Vietnamese project documentation
├── BUILD_ENVIRONMENTS.md               # Multi-environment build guide
├── ERROR_HANDLING_GUIDE.md             # Centralized error handling guide
└── fixes/                              # Bug fixes & troubleshooting
    ├── README.md                       # Fixes index
    └── trustwallet-crash/              # TrustWallet crash fix
        ├── README.md                   # Fix overview
        ├── TRUSTWALLETCORE_CRASH_FIX.md       # Technical docs (EN)
        └── CRASH_FIX_SUMMARY_VI.md            # Summary (VI)
```

## 📖 Documentation Structure

### General Documentation
- [README_VI.md](README_VI.md) - Vietnamese README for the project
- [BUILD_ENVIRONMENTS.md](BUILD_ENVIRONMENTS.md) - How to build for development/staging/production
- [ERROR_HANDLING_GUIDE.md](ERROR_HANDLING_GUIDE.md) - How to use `AppErrorHandler` and custom exception types

### Bug Fixes & Troubleshooting
- [TrustWallet Crash Fix](fixes/trustwallet-crash/) - Comprehensive documentation for fixing TrustWalletCore SIGSEGV crashes on Android

## 🔍 Quick Links

### For Developers
- **Setting up the project**: See main [README.md](../README.md)
- **Build environments**: See [BUILD_ENVIRONMENTS.md](BUILD_ENVIRONMENTS.md)
- **Error handling**: See [ERROR_HANDLING_GUIDE.md](ERROR_HANDLING_GUIDE.md)
- **Troubleshooting crashes**: See [fixes/](fixes/)
- **Vietnamese documentation**: See [README_VI.md](README_VI.md)

### For Bug Fixes
Navigate to specific fix documentation in the [fixes/](fixes/) directory.

## 📝 Contributing to Documentation

When adding new documentation:

1. **General guides**: Place in `docs/` root
2. **Bug fixes**: Create subfolder in `docs/fixes/[bug-name]/`
3. **Features**: Create subfolder in `docs/features/[feature-name]/`
4. **API docs**: Create subfolder in `docs/api/`

### Documentation Template

Each bug fix folder should contain:
- Technical documentation (English)
- Summary document (Vietnamese if applicable)
- Step-by-step guide for implementation
- Testing instructions

## 📋 Available Documentation

### Fixes
- [TrustWallet Crash Fix](fixes/trustwallet-crash/TRUSTWALLETCORE_CRASH_FIX.md) - Detailed technical documentation
  - [Summary (Vietnamese)](fixes/trustwallet-crash/CRASH_FIX_SUMMARY_VI.md)

---

**Last Updated:** 2025-10-20  
**Maintainers:** AuraPay Development Team


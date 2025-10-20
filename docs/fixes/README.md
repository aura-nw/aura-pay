# 🔧 Bug Fixes Documentation

This directory contains comprehensive documentation for bug fixes and troubleshooting guides.

## 📂 Available Fixes

### [TrustWallet Crash Fix](trustwallet-crash/)
**Issue:** SIGSEGV (Segmentation Fault) when generating HD Wallet on Android  
**Status:** ✅ Fixed  
**Date:** 2025-10-20  

**Documents:**
- [TRUSTWALLETCORE_CRASH_FIX.md](trustwallet-crash/TRUSTWALLETCORE_CRASH_FIX.md) - Complete technical documentation (English)
- [CRASH_FIX_SUMMARY_VI.md](trustwallet-crash/CRASH_FIX_SUMMARY_VI.md) - Quick summary in Vietnamese
- [NEXT_STEPS.md](trustwallet-crash/NEXT_STEPS.md) - Testing guide and next steps

**Key Changes:**
- Android minSdkVersion: 24 → 26
- Multi-layer crypto initialization
- Native SecureRandom priming
- CryptoInitializer helper class
- Enhanced error handling

---

## 📋 Document Structure

Each fix should follow this structure:

```
fixes/
└── [bug-name]/
    ├── README.md (optional - for complex fixes with multiple documents)
    ├── [BUG]_FIX.md (technical documentation in English)
    ├── [BUG]_SUMMARY_VI.md (summary in Vietnamese)
    └── NEXT_STEPS.md (implementation and testing guide)
```

## 🔍 Quick Search

### By Category
- **Crashes:** [TrustWallet Crash](trustwallet-crash/)
- **Build Issues:** Coming soon
- **Performance:** Coming soon

### By Platform
- **Android:** [TrustWallet Crash](trustwallet-crash/)
- **iOS:** Coming soon
- **Both:** Coming soon

### By Status
- **Fixed:** [TrustWallet Crash](trustwallet-crash/)
- **In Progress:** None
- **Pending:** None

---

## 📝 Adding New Fix Documentation

1. Create a new folder: `docs/fixes/[bug-name]/`
2. Add technical documentation: `[BUG]_FIX.md`
3. Add Vietnamese summary: `[BUG]_SUMMARY_VI.md`
4. Add implementation guide: `NEXT_STEPS.md`
5. Update this README with the new fix

---

**Last Updated:** 2025-10-20


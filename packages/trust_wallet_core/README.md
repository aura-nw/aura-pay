# trust_wallet_core

A Flutter plugin for trust wallet core, mapping all api list in [https://github.com/trustwallet/wallet-core/tree/master/include/TrustWalletCore](https://github.com/trustwallet/wallet-core/tree/master/include/TrustWalletCore)


# IMPORTANT

Because official lib build flag in CmakeLists.txt  set(CMAKE_CXX_VISIBILITY_PRESET hidden), that will cause android exception when dart ffi lookup function.

if you want to run android demo, follow this   [My other repo](https://github.com/weishirongzhen/flutter_trust_wallet_core_lib_include)  to run full demo,

# Android
Add 
```
class MainActivity: FlutterActivity() {
    init {
        System.loadLibrary("TrustWalletCore")
    }
}
 ```
in your android project MainActivity.kt file

minSdk require >=23

# iOS

min ios platform support >=13.0


# dart part
before use wallet_core, call below function once.
```
 FlutterTrustWalletCore.init();
```

Then you are ready to run.


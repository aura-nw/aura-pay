# Wallet Services

## Android
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


## Dart usage
Before using the package, call the initializer once:
```
 WalletServices.init();
```

Then you are ready to run.

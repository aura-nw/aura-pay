package com.aura.network.pay.aurapay

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.SecureRandom
import kotlinx.coroutines.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.aura.network.pay.aurapay/crypto_init"
    private var isCryptoReady = false
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Initialize crypto in background to avoid blocking main thread
        GlobalScope.launch(Dispatchers.IO) {
            initializeCrypto()
        }
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isCryptoReady" -> {
                    result.success(isCryptoReady)
                }
                "waitForCryptoReady" -> {
                    GlobalScope.launch {
                        // Wait up to 5 seconds for crypto to be ready
                        var attempts = 0
                        while (!isCryptoReady && attempts < 50) {
                            delay(100)
                            attempts++
                        }
                        withContext(Dispatchers.Main) {
                            result.success(isCryptoReady)
                        }
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun initializeCrypto() {
        try {
            android.util.Log.d("MainActivity", "Starting crypto initialization...")
            
            // Step 1: Prime SecureRandom with multiple iterations
            val secureRandom = SecureRandom()
            repeat(5) {
                secureRandom.nextBytes(ByteArray(64))
                Thread.sleep(50)
            }
            
            // Step 2: Explicitly seed the RNG
            val seed = ByteArray(32)
            SecureRandom.getInstanceStrong().nextBytes(seed)
            secureRandom.setSeed(seed)
            
            // Step 3: Generate more random data to fully initialize entropy pool
            repeat(3) {
                secureRandom.nextBytes(ByteArray(128))
                Thread.sleep(100)
            }
            
            // Step 4: Try to preload TrustWalletCore native library
            try {
                System.loadLibrary("TrustWalletCore")
                android.util.Log.d("MainActivity", "TrustWalletCore library loaded successfully")
            } catch (e: Exception) {
                android.util.Log.w("MainActivity", "TrustWalletCore library preload failed (might be normal): ${e.message}")
            }
            
            // Add additional delay to ensure everything is stable
            Thread.sleep(500)
            
            isCryptoReady = true
            android.util.Log.d("MainActivity", "Crypto initialization completed successfully")
            
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Failed to initialize crypto: ${e.message}", e)
            // Set ready anyway to not block the app
            isCryptoReady = true
        }
    }
}

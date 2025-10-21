# 🛡️ Error Handling Guide

Hướng dẫn sử dụng centralized error handling trong Pyxis Mobile app.

---

## 📋 Tổng quan

App sử dụng **centralized error handling** với:
- ✅ Custom exception types cho từng domain
- ✅ ErrorHandler tự động map errors thành user-friendly messages
- ✅ Tích hợp logging và toast notifications
- ✅ Consistent error handling across app

---

## 🎯 Quick Start

### Basic Usage

```dart
import 'package:aurapay/src/core/error/error.dart';

// Trong BLoC/Cubit
try {
  await someOperation();
} catch (e, stackTrace) {
  ErrorHandler.handle(e, stackTrace: stackTrace);
}
```

### With Custom Message

```dart
try {
  await fetchData();
} catch (e, stackTrace) {
  ErrorHandler.handle(
    e,
    stackTrace: stackTrace,
    customMessage: 'Failed to load data. Please try again.',
  );
}
```

### Without Toast (Silent Error)

```dart
try {
  await backgroundTask();
} catch (e, stackTrace) {
  ErrorHandler.handle(
    e,
    stackTrace: stackTrace,
    showToUser: false, // Chỉ log, không show toast
  );
}
```

---

## 🎨 Custom Exception Types

### 1. Network Exceptions

```dart
// Sử dụng factory methods
throw NetworkException.noConnection();
throw NetworkException.timeout();
throw NetworkException.serverError(500);

// Hoặc custom message
throw NetworkException(
  message: 'Custom network error',
  code: 'CUSTOM_CODE',
);
```

### 2. Wallet Exceptions

```dart
// Common wallet errors
throw WalletException.insufficientBalance();
throw WalletException.invalidAddress();
throw WalletException.invalidMnemonic();
throw WalletException.transactionFailed('Gas estimation failed');
throw WalletException.walletGenerationFailed();
```

### 3. Authentication Exceptions

```dart
throw AuthenticationException.unauthorized();
throw AuthenticationException.sessionExpired();
throw AuthenticationException.invalidCredentials();
```

### 4. Database Exceptions

```dart
throw DatabaseException.notFound('Account');
throw DatabaseException.saveFailed('Transaction');
throw DatabaseException.deleteFailed('Token');
```

### 5. Validation Exceptions

```dart
// Single field
throw ValidationException.requiredField('Email');
throw ValidationException.invalidInput('Amount', 'Must be greater than 0');

// Multiple fields
throw ValidationException(
  message: 'Form validation failed',
  fieldErrors: {
    'email': 'Invalid email format',
    'password': 'Password too short',
  },
);
```

### 6. Biometric Exceptions

```dart
throw BiometricException.notAvailable();
throw BiometricException.notEnrolled();
throw BiometricException.failed();
throw BiometricException.cancelled();
```

### 7. Storage Exceptions

```dart
throw StorageException.readFailed('userPreferences');
throw StorageException.writeFailed('cache');
throw StorageException.deleteFailed('tempData');
```

---

## 💡 Best Practices

### 1. Always Provide StackTrace

```dart
✅ GOOD:
try {
  await operation();
} catch (e, stackTrace) {
  ErrorHandler.handle(e, stackTrace: stackTrace);
}

❌ BAD:
try {
  await operation();
} catch (e) {
  ErrorHandler.handle(e); // Missing stackTrace!
}
```

### 2. Use Specific Exceptions

```dart
✅ GOOD:
if (balance < amount) {
  throw WalletException.insufficientBalance();
}

❌ BAD:
if (balance < amount) {
  throw Exception('Not enough balance');
}
```

### 3. Provide Context with Custom Messages

```dart
✅ GOOD:
try {
  await sendTransaction();
} catch (e, stackTrace) {
  ErrorHandler.handle(
    e,
    stackTrace: stackTrace,
    customMessage: 'Failed to send AURA tokens',
  );
}

⚠️ OKAY:
try {
  await sendTransaction();
} catch (e, stackTrace) {
  ErrorHandler.handle(e, stackTrace: stackTrace);
  // Will show generic message
}
```

### 4. Don't Catch and Rethrow Without Purpose

```dart
❌ BAD:
try {
  await operation();
} catch (e, stackTrace) {
  ErrorHandler.handle(e, stackTrace: stackTrace);
  rethrow; // Why handle if you rethrow?
}

✅ GOOD (if you need to do cleanup):
try {
  await operation();
} catch (e, stackTrace) {
  await cleanup();
  ErrorHandler.handle(e, stackTrace: stackTrace);
}
```

### 5. Silent Errors for Background Tasks

```dart
// Don't annoy users with toast for background sync
try {
  await backgroundSync();
} catch (e, stackTrace) {
  ErrorHandler.handle(
    e,
    stackTrace: stackTrace,
    showToUser: false,
  );
}
```

---

## 📝 Examples in Different Scenarios

### BLoC/Cubit

```dart
final class SendBloc extends Bloc<SendEvent, SendState> {
  void _onSendTransaction(
    SendTransactionEvent event,
    Emitter<SendState> emit,
  ) async {
    emit(state.copyWith(status: SendStatus.sending));
    
    try {
      final result = await _sendUseCase.send(event.transaction);
      
      emit(state.copyWith(
        status: SendStatus.success,
        txHash: result.hash,
      ));
      
      ToastHelper.showSuccess('Transaction sent successfully!');
    } catch (e, stackTrace) {
      ErrorHandler.handle(
        e,
        stackTrace: stackTrace,
        customMessage: 'Failed to send transaction',
      );
      
      emit(state.copyWith(status: SendStatus.error));
    }
  }
}
```

### Repository

```dart
class AccountRepositoryImpl implements AccountRepository {
  @override
  Future<Account> getAccount(int id) async {
    try {
      final accountDto = await _databaseService.get(id);
      
      if (accountDto == null) {
        throw DatabaseException.notFound('Account');
      }
      
      return accountDto.toEntity;
    } catch (e, stackTrace) {
      // Repository có thể log nhưng nên throw lên cho caller handle
      LogProvider.log('Failed to get account: $e');
      rethrow;
    }
  }
}
```

### Use Case

```dart
class SendTransactionUseCase {
  Future<TransactionResult> execute(Transaction tx) async {
    // Validation
    if (tx.amount <= 0) {
      throw ValidationException.invalidInput(
        'amount',
        'Amount must be greater than 0',
      );
    }
    
    if (!_isValidAddress(tx.toAddress)) {
      throw WalletException.invalidAddress();
    }
    
    try {
      // Business logic
      return await _walletService.sendTransaction(tx);
    } on NetworkException {
      // Let it bubble up
      rethrow;
    } catch (e) {
      // Wrap unknown errors
      throw WalletException.transactionFailed(e.toString());
    }
  }
}
```

### UI/Screen

```dart
class SendScreen extends StatelessWidget {
  void _onSendPressed(BuildContext context) {
    final bloc = context.read<SendBloc>();
    
    try {
      final transaction = _buildTransaction();
      bloc.add(SendTransactionEvent(transaction));
    } on ValidationException catch (e) {
      // Show validation errors in form
      _showValidationErrors(e.fieldErrors);
    } catch (e, stackTrace) {
      // Let ErrorHandler show toast
      ErrorHandler.handle(e, stackTrace: stackTrace);
    }
  }
}
```

---

## 🔍 Error Message Mapping

ErrorHandler tự động map các errors thành user-friendly messages:

| Error Type | User Message |
|------------|--------------|
| `NetworkException.noConnection()` | "No internet connection. Please check your network settings." |
| `NetworkException.timeout()` | "Request timeout. Please try again." |
| `NetworkException.serverError(500)` | "Server error occurred (Code: 500)." |
| `WalletException.insufficientBalance()` | "Insufficient balance for this transaction." |
| `WalletException.invalidAddress()` | "Invalid wallet address. Please check and try again." |
| `AuthenticationException.sessionExpired()` | "Your session has expired. Please login again." |
| `DatabaseException.notFound('Account')` | "Account not found." |

---

## 🎨 Toast Types

ErrorHandler sử dụng ToastHelper để show messages:

```dart
// Error toast (red, long duration)
ToastHelper.showError('Error message');

// Success toast (green)
ToastHelper.showSuccess('Success message');

// Warning toast (orange)
ToastHelper.showWarning('Warning message');

// Info toast (blue)
ToastHelper.showInfo('Info message');
```

---

## 🔧 Advanced Usage

### Check if Error is Critical

```dart
try {
  await operation();
} catch (e, stackTrace) {
  ErrorHandler.handle(e, stackTrace: stackTrace);
  
  if (ErrorHandler.isCriticalError(e)) {
    // Navigate to login or show critical error screen
    Navigator.pushReplacementNamed(context, '/login');
  }
}
```

### Get Error Code

```dart
try {
  await operation();
} catch (e, stackTrace) {
  final errorCode = ErrorHandler.getErrorCode(e);
  LogProvider.log('Error code: $errorCode');
  
  ErrorHandler.handle(e, stackTrace: stackTrace);
}
```

### Convert to AppException

```dart
Future<void> someMethod() async {
  try {
    await riskyOperation();
  } catch (e, stackTrace) {
    final appException = ErrorHandler.toAppException(e, stackTrace: stackTrace);
    
    // Now you can check specific exception types
    if (appException is NetworkException) {
      // Handle network error specifically
    }
    
    throw appException;
  }
}
```

---

## 📊 Error Logging

Tất cả errors được log với format:

```
❌ ERROR OCCURRED ❌
Time: 2025-10-21 10:30:45.123
Error Type: WalletException
Error: Insufficient balance for this transaction.
Error Code: WALLET_INSUFFICIENT_BALANCE
Stack Trace:
#0      SendBloc._onSendTransaction (package:aurapay/...)
#1      ...
════════════════════════════════════════
```

---

## 🚀 Migration Guide

### Before (Old Way)

```dart
try {
  final account = await _accountUseCase.getFirstAccount();
  emit(state.copyWith(account: account));
} catch (e) {
  print('Error: $e');
  Toast.show('Failed to load account');
}
```

### After (New Way)

```dart
try {
  final account = await _accountUseCase.getFirstAccount();
  emit(state.copyWith(account: account));
} catch (e, stackTrace) {
  ErrorHandler.handle(
    e,
    stackTrace: stackTrace,
    customMessage: 'Failed to load account',
  );
}
```

---

## ✅ Checklist khi Update BLoC

Khi update existing BLoC để dùng ErrorHandler:

- [ ] Import `'package:aurapay/src/core/error/error.dart'`
- [ ] Replace `print()` với `LogProvider.log()`
- [ ] Thêm `stackTrace` parameter vào catch blocks
- [ ] Sử dụng `ErrorHandler.handle()` thay vì manual logging
- [ ] Consider custom message cho better UX
- [ ] Remove manual Toast.show() calls (ErrorHandler handles it)
- [ ] Use specific exception types khi throw errors

---

## 🎯 Next Steps

1. **Add to All BLoCs**: Update tất cả BLoC/Cubit files
2. **Add Crash Analytics**: Integrate Firebase Crashlytics hoặc Sentry
3. **Localization**: Thêm i18n cho error messages
4. **Error Recovery**: Implement retry logic cho network errors

---

**Last Updated:** October 21, 2025  
**Status:** ✅ Implemented


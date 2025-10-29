import 'dart:developer' as developer;
import 'package:domain/domain.dart';

class LogProviderImpl implements LogProvider {
  @override
  void printLog(String message) {
    developer.log(message, name: 'aurapay');
  }
}


import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

sealed class DeviceHelper {
  static Future<String> getDeviceId() async {
    String deviceId;

    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceId = await const AndroidId().getId() ?? '';

      if (deviceId.isNotNullOrEmpty) return deviceId;

      final AndroidDeviceInfo androidDeviceInfo = await plugin.androidInfo;

      return androidDeviceInfo.device;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosDeviceInfo = await plugin.iosInfo;

      return iosDeviceInfo.identifierForVendor ?? '';
    }
    throw Exception('Not support platform');
  }
}

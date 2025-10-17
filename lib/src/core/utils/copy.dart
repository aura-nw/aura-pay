import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/constants/language_key.dart';
import 'package:aurapay/src/core/utils/toast.dart';

mixin Copy<T extends StatefulWidget> on CustomFlutterToast<T>{
  void copy(String value) async {
    await Clipboard.setData(
      ClipboardData(text: value),
    );

    if (Platform.isIOS) {
      if (mounted) {
        showToast(
          AppLocalizationManager.of(context).translateWithParam(
            LanguageKey.commonCopyValue,
            {
              'value': 'address',
            },
          ),
        );
      }
    }
  }
}
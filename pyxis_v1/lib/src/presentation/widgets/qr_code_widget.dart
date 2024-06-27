import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatefulWidget {
  final String rawData;
  final AppTheme appTheme;
  final VoidCallback? onCopySuccess;

  const QrCodeWidget({
    required this.rawData,
    required this.appTheme,
    this.onCopySuccess,
    super.key,
  });

  @override
  State<QrCodeWidget> createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends State<QrCodeWidget> with CustomFlutterToast {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        QrImageView(
          data: widget.rawData,
          version: QrVersions.auto,
          padding: EdgeInsets.zero,
          backgroundColor: widget.appTheme.bodyColorBackground,
          size: context.w / 2,
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.rawData.addressView,
              style: AppTypoGraPhy.bodyMedium03.copyWith(
                color: widget.appTheme.contentColorBlack,
              ),
            ),
            const SizedBox(
              width: BoxSize.boxSize04,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(text: widget.rawData),
                );

                if (Platform.isIOS) {
                  if (context.mounted) {
                    showToast(
                      AppLocalizationManager.of(context).translateWithParam(
                        LanguageKey.globalPyxisCopyMessage,
                        {
                          'value': 'address',
                        },
                      ),
                    );
                  }
                }

                widget.onCopySuccess?.call();
              },
              child: SvgPicture.asset(
                AssetIconPath.commonCopy,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

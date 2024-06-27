import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/backup_private_key/backup_private_key_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';

class BackupPrivateKeyFormWidget extends StatelessWidget {
  final AppTheme appTheme;
  final void Function(String) onCopy;

  const BackupPrivateKeyFormWidget({
    required this.appTheme,
    required this.onCopy,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BackupPrivateKeyShowPrivateKeySelector(
          builder: (showPrivateKey) {
            if (showPrivateKey) {
              return Container(
                padding: const EdgeInsets.all(
                  Spacing.spacing04,
                ),
                height: BoxSize.boxSize14,
                decoration: BoxDecoration(
                  color: appTheme.surfaceColorGrayLight,
                  borderRadius: BorderRadius.circular(
                    BorderRadiusSize.borderRadius04,
                  ),
                ),
                alignment: Alignment.topLeft,
                child: BackupPrivateKeyPrivateKeySelector(
                  builder: (privateKey) {
                    return Text(
                      privateKey,
                      style: AppTypoGraPhy.body02.copyWith(
                        color: appTheme.contentColorBlack,
                      ),
                    );
                  },
                ),
              );
            }
            return SvgPicture.asset(
              AssetImagePath.commonHidePhrase,
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        BackupPrivateKeyPrivateKeySelector(
          builder: (privateKey) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onCopy(privateKey),
              child: TextWithIconWidget(
                mainAxisAlignment: MainAxisAlignment.end,
                titlePath: LanguageKey.backupPrivateKeyScreenCopy,
                svgIconPath: AssetIconPath.commonCopyActive,
                appTheme: appTheme,
                style: AppTypoGraPhy.bodyMedium02.copyWith(
                  color: appTheme.contentColorBrand,
                ),
              ),
            );
          }
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/core/utils/aura_util.dart';
import 'package:pyxis_v2/src/presentation/screens/send/send_selector.dart';
import 'package:pyxis_v2/src/presentation/widgets/divider_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/wallet_info_widget.dart';

final class SendScreenFromWidget extends StatelessWidget {
  final AppTheme appTheme;
  final AppLocalizationManager localization;
  final EdgeInsetsGeometry padding;

  const SendScreenFromWidget({
    required this.appTheme,
    required this.localization,
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.translate(
                  LanguageKey.sendScreenFrom,
                ),
                style: AppTypoGraPhy.textSmSemiBold.copyWith(
                  color: appTheme.textPrimary,
                ),
              ),
              const SizedBox(
                height: BoxSize.boxSize05,
              ),
              SendFromSelector(
                  builder: (account) {
                    return DefaultWalletInfoWidget(
                      avatarAsset: randomAvatar(),
                      appTheme: appTheme,
                      title: account?.name ?? '',
                      address: account?.evmAddress ?? '',
                    );
                  }
              ),
            ],
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        HoLiZonTalDividerWidget(
          appTheme: appTheme,
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/json_formatter.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_box_widget.dart';

class WalletConnectConfirmTransactionMessageWidget extends StatelessWidget {
  final AppTheme appTheme;
  final Map<String, dynamic> messages;

  const WalletConnectConfirmTransactionMessageWidget({
    required this.appTheme,
    required this.messages,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppLocalizationProvider(
              builder: (localization, _) {
                return Text(
                  localization.translate(
                    LanguageKey.recoveryMethodConfirmationScreenMessages,
                  ),
                  style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                );
              },
            ),
            Row(
              children: [
                SvgPicture.asset(
                  AssetIconPath.commonViewRawActive,
                ),
                const SizedBox(
                  width: BoxSize.boxSize03,
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return Text(
                      localization.translate(
                        LanguageKey.recoveryMethodConfirmationScreenViewData,
                      ),
                      style: AppTypoGraPhy.bodyMedium02
                          .copyWith(color: appTheme.contentColorBrand),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        TransactionBoxWidget(
            appTheme: appTheme,
            child: ScrollBarWidget(
              appTheme: appTheme,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: BoxSize.boxSize15,
                  minHeight: BoxSize.boxSize13,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    prettyJson(messages),
                    style: AppTypoGraPhy.body02.copyWith(
                      color: appTheme.contentColor500,
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

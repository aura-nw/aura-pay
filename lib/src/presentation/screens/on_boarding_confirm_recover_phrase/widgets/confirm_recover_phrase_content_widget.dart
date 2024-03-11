import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/phrase_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

class ConfirmRecoverPhraseContentWidget extends StatelessWidget {
  final TextEditingController confirmPhraseController;
  final TextEditingController walletNameController;
  final AppTheme appTheme;

  const ConfirmRecoverPhraseContentWidget({
    required this.confirmPhraseController,
    required this.walletNameController,
    required this.appTheme,
    super.key,
  });

  final int _maxWalletNameLength = 32;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SvgPicture.asset(''),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                '',
              ),
            );
          },
        ),
        TextInputNormalWidget(
          controller: confirmPhraseController,
          constraintManager: ConstraintManager()
            ..custom(
              errorMessage: '',
              customValid: (text) {
                return false;
              },
            ),
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translateWithParam(
                '',
                {},
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        Container(
          padding: const EdgeInsets.all(
            Spacing.spacing03,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              BorderRadiusSize.borderRadius03,
            ),
            color: appTheme.surfaceColorBlack.withOpacity(
              0.04,
            ),
          ),
          child: Row(
            children: List.generate(
              [].length,
              (index) => Expanded(
                child: PhraseWidget(
                  position: index + 1,
                  word: 'word',
                  appTheme: appTheme,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppLocalizationProvider(
              builder: (localization, _) {
                return Text(
                  localization.translate(''),
                  style: AppTypoGraPhy.utilityLabelSm.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                );
              },
            ),
            Text(
              '${walletNameController.text.trim().length}/$_maxWalletNameLength',
              style: AppTypoGraPhy.bodyMedium01.copyWith(
                color: appTheme.contentColor300,
              ),
            ),
          ],
        ),
        TextInputNormalWidget(
          maxLength: _maxWalletNameLength,
          controller: walletNameController,
        ),
      ],
    );
  }
}

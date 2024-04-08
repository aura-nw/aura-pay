import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/pass_phrase_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/phrase_widget.dart';

class RecoveryPhraseWidget extends StatelessWidget {
  final String phrase;
  final void Function(String) onCopy;
  final AppTheme appTheme;

  const RecoveryPhraseWidget({
    required this.phrase,
    required this.onCopy,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PassPhraseWidget(
          phrase: phrase,
          onCopy: onCopy,
          appTheme: appTheme,
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        GestureDetector(
          onTap: () => onCopy(phrase),
          behavior: HitTestBehavior.opaque,
          child: TextWithIconWidget(
            titlePath: LanguageKey.signedInRecoverPhraseScreenCopy,
            svgIconPath: AssetIconPath.commonCopyActive,
            appTheme: appTheme,
            style: AppTypoGraPhy.bodyMedium02.copyWith(
              color: appTheme.contentColorBrand,
            ),
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ),
      ],
    );
  }
}

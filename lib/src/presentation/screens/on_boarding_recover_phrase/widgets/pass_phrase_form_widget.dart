import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/phrase_widget.dart';

class RecoveryPhraseWidget extends StatelessWidget {
  final String phrase;
  final AppTheme appTheme;

  const RecoveryPhraseWidget({
    required this.phrase,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> words = phrase.split(' ');
    return Column(
      children: [
        Wrap(
          children: List.generate(
            words.length,
            (index) {
              final String word = words[index];
              return PhraseWidget(
                position: index + 1,
                word: word,
                appTheme: appTheme,
              );
            },
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconWithTextWidget(
              titlePath: '',
              svgIconPath: '',
              appTheme: appTheme,
            ),
            TextWithIconWidget(
              titlePath: '',
              svgIconPath: '',
              appTheme: appTheme,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDefaultPhraseView() {
    return SvgPicture.asset('');
  }
}

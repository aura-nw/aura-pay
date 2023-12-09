import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';

class RenameAccountFormWidget extends StatefulWidget {
  final String address;
  final String accountNameDefault;
  final void Function(String) onConfirm;
  final AppTheme appTheme;

  const RenameAccountFormWidget({
    required this.appTheme,
    required this.address,
    required this.accountNameDefault,
    required this.onConfirm,
    super.key,
  });

  @override
  State<RenameAccountFormWidget> createState() =>
      _RenameAccountFormWidgetState();
}

class _RenameAccountFormWidgetState extends State<RenameAccountFormWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.accountNameDefault;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        Spacing.spacing06,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  LanguageKey.accountsPageRenameAccount,
                ),
                style: AppTypoGraPhy.heading02.copyWith(
                  color: widget.appTheme.contentColorBlack,
                ),
              );
            },
          ),
          const SizedBox(
            height: BoxSize.boxSize08,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: AppLocalizationProvider(
              builder: (localization, _) {
                return RichText(
                  text: TextSpan(
                    style: AppTypoGraPhy.bodyMedium03.copyWith(
                      color: widget.appTheme.contentColorBlack,
                    ),
                    children: [
                      TextSpan(
                        text: localization.translate(
                          LanguageKey
                              .accountsPageRenameAccountMakeMemorableRegionOne,
                        ),
                      ),
                      TextSpan(
                        text: ' ${widget.address.addressView} ',
                        style: AppTypoGraPhy.bodyMedium03.copyWith(
                          color: widget.appTheme.contentColorBrand,
                        ),
                      ),
                      TextSpan(
                        text: localization.translate(
                          LanguageKey
                              .accountsPageRenameAccountMakeMemorableRegionTwo,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: BoxSize.boxSize06,
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return TextInputNormalWidget(
                hintText: localization.translate(
                  LanguageKey.accountsPageRenameAccountHint,
                ),
                maxLength: 500,
                maxLine: 1,
                controller: _controller,
              );
            },
          ),
          const SizedBox(
            height: BoxSize.boxSize09,
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return PrimaryAppButton(
                text: localization.translate(
                  LanguageKey.accountsPageRenameAccountConfirm,
                ),
                onPress: () {
                  widget.onConfirm(
                    _controller.text.trim(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

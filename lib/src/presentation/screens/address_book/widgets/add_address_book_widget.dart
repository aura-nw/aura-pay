import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/helpers/wallet_address_validator.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

class AddAddressBookWidget extends AppBottomSheetBase {
  final void Function(String address, String name) onConfirm;

  const AddAddressBookWidget({
    required this.onConfirm,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AddAddressBookWidgetState();
}

class _AddAddressBookWidgetState
    extends AppBottomSheetBaseState<AddAddressBookWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool isValidName = false;
  bool isValidAddress = false;

  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return AppLocalizationProvider(
      builder: (localization, _) {
        return Text(
          localization.translate(
            LanguageKey.addressBookScreenAddContactTitle,
          ),
          style: AppTypoGraPhy.heading02.copyWith(
            color: appTheme.contentColorBlack,
          ),
        );
      },
    );
  }

  @override
  Widget bottomBuilder(BuildContext context, AppTheme appTheme) {
    bool isValid = isValidAddress && isValidName;
    return AppLocalizationProvider(
      builder: (localization, _) {
        return PrimaryAppButton(
          text: localization.translate(
            LanguageKey.addressBookScreenAddContactConfirm,
          ),
          isDisable: !isValid,
          onPress: () {
            AppNavigator.pop();
            widget.onConfirm(
              _addressController.text.trim(),
              _nameController.text.trim(),
            );
          },
        );
      },
    );
  }

  @override
  Widget contentBuilder(BuildContext context, AppTheme appTheme) {
    return AppLocalizationProvider(
      builder: (localization, _) {
        return Column(
          children: [
            TextInputNormalWidget(
              label: localization.translate(
                LanguageKey.addressBookScreenAddContactName,
              ),
              isRequired: true,
              onChanged: (_, isValid) {
                setState(() {
                  isValidName = isValid;
                });
              },
              controller: _nameController,
              maxLength: 255,
              constraintManager: ConstraintManager()
                ..notEmpty(
                  errorMessage: localization.translate(
                    LanguageKey.addressBookScreenInvalidName,
                  ),
                ),
            ),
            const SizedBox(
              height: BoxSize.boxSize05,
            ),
            TextInputNormalWidget(
              label: localization.translate(
                LanguageKey.addressBookScreenAddContactAddress,
              ),
              onChanged: (_, isValid) {
                setState(() {
                  isValidAddress = isValid;
                });
              },
              controller: _addressController,
              isRequired: true,
              constraintManager: ConstraintManager()
                ..custom(
                  customValid: (value) {
                    return WalletAddressValidator.isValidAddress(
                      value,
                    );
                  },
                  errorMessage: localization.translate(
                    LanguageKey.addressBookScreenInvalidAddress,
                  ),
                ),
            ),
            const SizedBox(
              height: BoxSize.boxSize07,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget subTitleBuilder(BuildContext context, AppTheme appTheme) {
    return const SizedBox.shrink();
  }
}

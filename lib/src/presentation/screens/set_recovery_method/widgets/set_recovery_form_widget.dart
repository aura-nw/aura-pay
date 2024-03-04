import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/helpers/wallet_address_validator.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

final class _SetRecoveryOptionWidget extends StatelessWidget {
  final String methodIconPath;
  final String titleKey;
  final String contentKey;
  final Widget? subContent;
  final bool isSelected;
  final AppTheme appTheme;
  final VoidCallback onTap;

  const _SetRecoveryOptionWidget({
    required this.contentKey,
    required this.titleKey,
    required this.methodIconPath,
    this.subContent,
    this.isSelected = false,
    required this.appTheme,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(
          Spacing.spacing04,
        ),
        margin: const EdgeInsets.only(
          bottom: BoxSize.boxSize05,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? appTheme.surfaceColorBrandLight
              : appTheme.surfaceColorWhite,
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadius04,
          ),
          border: Border.all(
            color: isSelected
                ? appTheme.borderColorBrand
                : appTheme.borderColorGrayDefault,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  methodIconPath,
                ),
                const SizedBox(
                  width: BoxSize.boxSize05,
                ),
                SvgPicture.asset(
                  isSelected
                      ? AssetIconPath.commonRadioCheck
                      : AssetIconPath.commonRadioUnCheck,
                ),
              ],
            ),
            const SizedBox(
              height: BoxSize.boxSize03,
            ),
            AppLocalizationProvider(
              builder: (localization, _) {
                return Text(
                  localization.translate(
                    titleKey,
                  ),
                  style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                );
              },
            ),
            const SizedBox(
              height: BoxSize.boxSize02,
            ),
            AppLocalizationProvider(
              builder: (localization, _) {
                return Text(
                  localization.translate(
                    contentKey,
                  ),
                  style: AppTypoGraPhy.body02.copyWith(
                    color: appTheme.contentColor500,
                  ),
                );
              },
            ),
            if (subContent != null)
              Column(
                children: [
                  const SizedBox(
                    height: BoxSize.boxSize06,
                  ),
                  subContent!,
                ],
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

final class SetRecoveryFormWidget extends StatefulWidget {
  final AppTheme appTheme;
  final void Function(RecoverOptionType) onChange;
  final void Function(String, bool) onAddressChange;
  final RecoverOptionType selectedMethod;

  const SetRecoveryFormWidget({
    required this.appTheme,
    required this.onChange,
    required this.onAddressChange,
    this.selectedMethod = RecoverOptionType.google,
    super.key,
  });

  @override
  State<SetRecoveryFormWidget> createState() => _SetRecoveryFormWidgetState();
}

class _SetRecoveryFormWidgetState extends State<SetRecoveryFormWidget> {
  RecoverOptionType _indexSelected = RecoverOptionType.google;

  final TextEditingController _addressController = TextEditingController();

  bool get isGoogleSelected => _indexSelected == RecoverOptionType.google;

  bool get isBackupAddressSelected =>
      _indexSelected == RecoverOptionType.backupAddress;

  @override
  void initState() {
    _indexSelected = widget.selectedMethod;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SetRecoveryFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _indexSelected = widget.selectedMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SetRecoveryOptionWidget(
          contentKey:
              LanguageKey.setRecoveryMethodScreenConnectGoogleAccountContent,
          titleKey:
              LanguageKey.setRecoveryMethodScreenConnectGoogleAccountTitle,
          methodIconPath: AssetIconPath.commonGoogle,
          appTheme: widget.appTheme,
          isSelected: isGoogleSelected,
          onTap: () {
            _onTap(RecoverOptionType.google);
          },
          subContent: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppLocalizationProvider(
                builder: (localization, _) {
                  return Text(
                    localization.translate(
                      LanguageKey
                          .setRecoveryMethodScreenConnectGoogleAccountPoweredBy,
                    ),
                    style: AppTypoGraPhy.bodyMedium01.copyWith(
                      color: widget.appTheme.contentColor500,
                    ),
                  );
                },
              ),
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
              SvgPicture.asset(
                AssetIconPath.setRecoveryMethodWeb3Auth,
              ),
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
              AppLocalizationProvider(
                builder: (localization, _) {
                  return Text(
                    localization.translate(
                      LanguageKey
                          .setRecoveryMethodScreenConnectGoogleAccountWeb3Auth,
                    ),
                    style: AppTypoGraPhy.body01.copyWith(
                      color: widget.appTheme.contentColor500,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        _SetRecoveryOptionWidget(
          contentKey:
              LanguageKey.setRecoveryMethodScreenAddBackupAddressContent,
          titleKey: LanguageKey.setRecoveryMethodScreenAddBackupAddressTitle,
          methodIconPath: AssetIconPath.setRecoveryMethodBackupAddress,
          appTheme: widget.appTheme,
          isSelected: isBackupAddressSelected,
          onTap: () {
            _onTap(RecoverOptionType.backupAddress);
          },
          subContent: isBackupAddressSelected
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Spacing.spacing01,
                    horizontal: Spacing.spacing04,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      BorderRadiusSize.borderRadiusRound,
                    ),
                    color: widget.appTheme.bodyColorBackground,
                    border: Border.all(
                      color: widget.appTheme.borderColorGrayDefault,
                    ),
                  ),
                  child: AppLocalizationProvider(
                    builder: (localization, _) {
                      return TextInputOnlyTextFieldWidget(
                        enableClear: true,
                        onClear: () {
                          _addressController.clear();
                        },
                        controller: _addressController,
                        hintText: localization.translate(
                          LanguageKey
                              .setRecoveryMethodScreenAddBackupAddressHint,
                        ),
                        onChanged: widget.onAddressChange,
                        constraintManager: ConstraintManager()
                          ..custom(
                            errorMessage: localization.translate(
                              LanguageKey
                                  .setRecoveryMethodScreenAddBackupAddressInvalid,
                            ),
                            customValid: (address) {
                              return WalletAddressValidator.isValidAddress(
                                address.trim(),
                              );
                            },
                          ),
                      );
                    },
                  ),
                )
              : null,
        ),
      ],
    );
  }

  void _onTap(RecoverOptionType method) {
    if (_indexSelected == method) return;
    setState(() {
      _indexSelected = method;
    });
    widget.onChange(method);
  }
}

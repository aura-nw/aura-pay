import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

class NFTDetailInformationFormWidget extends StatelessWidget {
  final String name;
  final String blockChain;
  final String contractAddress;
  final AppTheme appTheme;
  final VoidCallback onCopy;

  const NFTDetailInformationFormWidget({
    required this.name,
    required this.blockChain,
    required this.contractAddress,
    required this.appTheme,
    required this.onCopy,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NFTDetailInformationWidget(
          appTheme: appTheme,
          titleKey: LanguageKey.nftDetailScreenName,
          value: name,
        ),
        _NFTDetailInformationWidget(
          appTheme: appTheme,
          titleKey: LanguageKey.nftDetailScreenBlockChain,
          value: blockChain,
        ),
        _NFTDetailInformationWidget(
          appTheme: appTheme,
          titleKey: LanguageKey.nftDetailScreenTokenStandardTitle,
          value: '',
          valueBuilder: AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  LanguageKey.nftDetailScreenTokenStandard,
                ),
                style: AppTypoGraPhy.body03.copyWith(
                  color: appTheme.contentColor700,
                ),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
        _NFTDetailInformationWidget(
          appTheme: appTheme,
          titleKey: LanguageKey.nftDetailScreenContractAddress,
          value: '',
          valueBuilder: GestureDetector(
            onTap: onCopy,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    contractAddress.addressView,
                    style: AppTypoGraPhy.body03.copyWith(
                      color: appTheme.contentColor700,
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: BoxSize.boxSize04,
                ),
                SvgPicture.asset(
                  AssetIconPath.commonCopy,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NFTDetailInformationWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String titleKey;
  final String value;
  final Widget? valueBuilder;

  const _NFTDetailInformationWidget({
    required this.appTheme,
    super.key,
    required this.titleKey,
    required this.value,
    this.valueBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing06,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppLocalizationProvider(
              builder: (localization, _) {
                return Text(
                  localization.translate(
                    titleKey,
                  ),
                  style: AppTypoGraPhy.bodyMedium03.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                  textAlign: TextAlign.start,
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: valueBuilder ??
                Text(
                  value,
                  style: AppTypoGraPhy.body03.copyWith(
                    color: appTheme.contentColor700,
                  ),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'widgets/nft_detail_information_widget.dart';
import 'widgets/nft_media_builder.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class NFTDetailScreen extends StatefulWidget {
  final NFTInformation nftInformation;

  const NFTDetailScreen({
    required this.nftInformation,
    super.key,
  });

  @override
  State<NFTDetailScreen> createState() => _NFTDetailScreenState();
}

class _NFTDetailScreenState extends State<NFTDetailScreen>
    with CustomFlutterToast {
  final config = getIt.get<PyxisMobileConfig>();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          backgroundColor: appTheme.bodyColorBackground,
          appBar: AppBarWithTitle(
            appTheme: appTheme,
            titleKey: '#${widget.nftInformation.tokenId}',
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing05,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  NFTMediaBuilder(
                    mediaInfo: widget.nftInformation.mediaInfo.offChain,
                    appTheme: appTheme,
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize06,
                  ),
                  NFTDetailInformationFormWidget(
                    name: widget.nftInformation.cw721Contract.name,
                    blockChain: config.chainName,
                    contractAddress:
                        widget.nftInformation.cw721Contract.smartContract.address,
                    appTheme: appTheme,
                    onCopy: _onCopy,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onCopy() async {
    await Clipboard.setData(
      ClipboardData(
        text: widget.nftInformation.cw721Contract.smartContract.address,
      ),
    );

    if (Platform.isIOS) {
      if (context.mounted) {
        showToast(
          AppLocalizationManager.of(context).translateWithParam(
            LanguageKey.globalPyxisCopyMessage,
            {
              'value': 'address',
            },
          ),
        );
      }
    }
  }
}

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/core/utils/app_util.dart';
import 'package:pyxis_v2/src/presentation/screens/send/send_selector.dart';

final class SendAppBar extends StatelessWidget {
  final AppTheme appTheme;
  final AppLocalizationManager localization;
  final void Function(List<AppNetwork>,Account?) onSelectNetwork;

  const SendAppBar({
    required this.appTheme,
    required this.localization,
    required this.onSelectNetwork,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          localization.translate(
            LanguageKey.sendScreenAppBarTitle,
          ),
          style: AppTypoGraPhy.textMdBold.copyWith(
            color: appTheme.textPrimary,
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize02,
        ),
        SendAppNetworksSelector(
          builder: (networks) {
            return SendSelectedNetworkSelector(
              builder: (selectedNetwork) {
                return SendFromSelector(
                  builder: (account) {
                    return GestureDetector(
                      onTap: () {
                        onSelectNetwork(networks,account);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            selectedNetwork.logo,
                            width: BoxSize.boxSize04,
                            height: BoxSize.boxSize04,
                          ),
                          const SizedBox(
                            width: BoxSize.boxSize02,
                          ),
                          Text(
                            selectedNetwork.name,
                            style: AppTypoGraPhy.textXsSemiBold.copyWith(
                              color: appTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(
                            width: BoxSize.boxSize02,
                          ),
                          SvgPicture.asset(
                            AssetIconPath.icCommonArrowDown,
                            width: BoxSize.boxSize04,
                            height: BoxSize.boxSize04,
                          ),
                        ],
                      ),
                    );
                  }
                );
              },
            );
          },
        ),
      ],
    );
  }
}

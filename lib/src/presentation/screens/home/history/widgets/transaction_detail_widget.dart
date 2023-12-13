import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_view_widget.dart';

class TransactionDetailWidget extends StatelessWidget {
  final AppTheme appTheme;
  final PyxisTransaction pyxisTransaction;
  final bool isReceive;

  const TransactionDetailWidget({
    required this.appTheme,
    required this.pyxisTransaction,
    required this.isReceive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing08,
        top: Spacing.spacing04,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScrollViewWidget(
            appTheme: appTheme,
          ),
          const SizedBox(
            height: BoxSize.boxSize04,
          ),
          Text(
            '',
            style: AppTypoGraPhy.heading02.copyWith(
              color: appTheme.contentColorBlack,
            ),
          ),
          const SizedBox(
            height: BoxSize.boxSize04,
          ),
          !isReceive
              ? SvgPicture.asset(AssetIconPath.historySendLogoCircle)
              : SvgPicture.asset(
                  AssetIconPath.historyReceiveLogoCircle,
                ),
        ],
      ),
    );
  }
}

class _TransactionInformationForm extends StatelessWidget {
  final AppTheme appTheme;

  const _TransactionInformationForm({
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing05,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorGrayLight,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius04,
        ),
      ),
      child: Column(
        children: [
          HoLiZonTalDividerWidget(),
        ],
      ),
    );
  }
}

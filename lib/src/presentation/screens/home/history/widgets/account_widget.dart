import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/aura_smart_account_base_widget.dart';

final class HistoryAccountWidget extends AuraSmartAccountBaseWidget {
  final VoidCallback onShowMoreAccount;

  const HistoryAccountWidget({
    required this.onShowMoreAccount,
    required super.appTheme,
    required super.address,
    required super.accountName,
    super.key,
  });

  @override
  Widget accountNameBuilder(BuildContext context) {
    return Text(
      accountName,
      style: AppTypoGraPhy.heading02.copyWith(
        color: appTheme.contentColorBlack,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget actionFormBuilder(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onShowMoreAccount,
      child: SvgPicture.asset(
        AssetIconPath.historyArrowDown,
      ),
    );
  }

  @override
  Widget addressBuilder(BuildContext context) {
    return Text(
      address.addressView,
      style: AppTypoGraPhy.body02.copyWith(
        color: appTheme.contentColor300,
      ),
    );
  }

  @override
  Widget avatarBuilder(BuildContext context) {
    return SvgPicture.asset(
      AssetIconPath.commonSmartAccountAvatarDefault,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/aura_smart_account_base_widget.dart';

class SenderWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String address;
  final String accountName;

  const SenderWidget({
    required this.appTheme,
    required this.address,
    required this.accountName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing04,
        vertical: Spacing.spacing05,
      ),
      margin: const EdgeInsets.only(
        top: Spacing.spacing06,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorGrayLight,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius05,
        ),
      ),
      child: _SenderAccountWidget(
        appTheme: appTheme,
        address: address,
        accountName: accountName,
      ),
    );
  }
}

class _SenderAccountWidget extends AuraSmartAccountBaseWidget {
  const _SenderAccountWidget({
    required super.appTheme,
    required super.address,
    required super.accountName,
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
    return const SizedBox();
  }

  @override
  Widget addressBuilder(BuildContext context) {
    return Text(
      address.addressView,
      style: AppTypoGraPhy.body02.copyWith(
        color: appTheme.contentColor500,
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

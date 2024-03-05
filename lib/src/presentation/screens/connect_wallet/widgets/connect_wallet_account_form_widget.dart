import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/aura_smart_account_base_widget.dart';

class ConnectWalletAccountFormWidget extends AuraSmartAccountBaseWidget {
  const ConnectWalletAccountFormWidget({
    required super.appTheme,
    required super.address,
    required super.accountName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing04,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorGrayLight,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius05,
        ),
      ),
      child: super.build(context),
    );
  }

  @override
  Widget accountNameBuilder(BuildContext context) {
    return Text(
      accountName,
      style: AppTypoGraPhy.heading01.copyWith(
        color: appTheme.contentColor700,
      ),
    );
  }

  @override
  Widget actionFormBuilder(BuildContext context) {
    return SvgPicture.asset(
      AssetIconPath.commonArrowNext,
    );
  }

  @override
  Widget addressBuilder(BuildContext context) {
    return Text(
      address.addressView,
      style: AppTypoGraPhy.body02.copyWith(
        color: appTheme.contentColor700,
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

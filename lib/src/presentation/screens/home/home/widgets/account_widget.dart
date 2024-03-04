import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/aura_smart_account_base_widget.dart';
import 'package:domain/domain.dart';

// Define a class named HomeAccountChangeWidget that extends AuraSmartAccountBaseWidget
final class HomeAccountChangeWidget extends AuraSmartAccountBaseWidget {
  final AuraAccount account;
  final bool isFirst;

  HomeAccountChangeWidget({
    required this.account,
    required this.isFirst,
    required super.appTheme,
    super.key,
  }) : super(
          address: account.address,
          accountName: account.name,
        );

  // Override the accountNameBuilder method
  @override
  Widget accountNameBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          accountName,
          style: AppTypoGraPhy.heading02.copyWith(
            color: appTheme.contentColorBlack,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // If isFirst is true, display a SizedBox and SvgPicture.asset
        if (isFirst) ...[
          const SizedBox(
            width: BoxSize.boxSize03,
          ),
          SvgPicture.asset(
            AssetIconPath.commonRadioCheck,
          )
        ] else
          const SizedBox.shrink(),
      ],
    );
  }

  // Override the actionFormBuilder method
  @override
  Widget actionFormBuilder(BuildContext context) {
    // If the account is a smart account, return an empty Container
    if (account.isSmartAccount) {
      return Container();
    }
    return const SizedBox.shrink();
  }

  // Override the addressBuilder method
  @override
  Widget addressBuilder(BuildContext context) {
    return Text(
      address.addressView,
      style: AppTypoGraPhy.body02.copyWith(
        color: appTheme.contentColor300,
      ),
    );
  }

  // Override the avatarBuilder method
  @override
  Widget avatarBuilder(BuildContext context) {
    return SvgPicture.asset(
      AssetIconPath.commonSmartAccountAvatarDefault,
    );
  }
}

// Define a private class named _HomeAccountWidget that extends AuraSmartAccountBaseWidget
final class _HomeAccountWidget extends AuraSmartAccountBaseWidget {
  final void Function(String) onCopy;

  const _HomeAccountWidget({
    required this.onCopy,
    required super.appTheme,
    required super.address,
    required super.accountName,
    super.key,
  });

  // Override the accountNameBuilder method
  @override
  Widget accountNameBuilder(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        onCopy(
          address,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            accountName,
            style: AppTypoGraPhy.heading02.copyWith(
              color: appTheme.contentColorWhite,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            width: BoxSize.boxSize04,
          ),
          SvgPicture.asset(
            AssetIconPath.homeCopy,
          ),
        ],
      ),
    );
  }

  // Override the actionFormBuilder method
  @override
  Widget actionFormBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Spacing.spacing04,
        bottom: Spacing.spacing04,
        left: Spacing.spacing04,
      ),
      child: SvgPicture.asset(
        AssetIconPath.commonArrowNext,
      ),
    );
  }

  // Override the addressBuilder method
  @override
  Widget addressBuilder(BuildContext context) {
    return Text(
      address.addressView,
      style: AppTypoGraPhy.body02.copyWith(
        color: appTheme.contentColor300,
      ),
    );
  }

  // Override the avatarBuilder method
  @override
  Widget avatarBuilder(BuildContext context) {
    return SvgPicture.asset(
      AssetIconPath.commonSmartAccountAvatarDefault,
    );
  }
}

// Define a private class named _HomeAccountReceiveWidget that extends AuraSmartAccountBaseWidget
final class _HomeAccountReceiveWidget extends AuraSmartAccountBaseWidget {
  const _HomeAccountReceiveWidget({
    required super.appTheme,
    required super.address,
    required super.accountName,
    super.key,
  });

  // Override the accountNameBuilder method
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

  // Override the actionFormBuilder method
  @override
  Widget actionFormBuilder(BuildContext context) {
    return SvgPicture.asset(
      AssetIconPath.homeReceiveCopyAddress,
    );
  }

  // Override the addressBuilder method
  @override
  Widget addressBuilder(BuildContext context) {
    return Text(
      address.addressView,
      style: AppTypoGraPhy.body02.copyWith(
        color: appTheme.contentColor700,
      ),
    );
  }

  // Override the avatarBuilder method
  @override
  Widget avatarBuilder(BuildContext context) {
    return SvgPicture.asset(
      AssetIconPath.commonSmartAccountAvatarDefault,
    );
  }
}

// Define a class named AccountCardWidget
class AccountCardWidget extends StatelessWidget {
  final VoidCallback onShowMoreAccount;
  final void Function(String) onCopy;
  final AppTheme appTheme;
  final String accountName;
  final String address;

  const AccountCardWidget({
    super.key,
    required this.onCopy,
    required this.onShowMoreAccount,
    required this.accountName,
    required this.address,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onShowMoreAccount,
      child: Container(
        padding: const EdgeInsets.all(
          Spacing.spacing06,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadius05,
          ),
          gradient: LinearGradient(
            colors: [
              appTheme.surfaceColorBlack,
              const Color(
                0xff302E5C,
              ),
            ],
          ),
        ),
        child: _HomeAccountWidget(
          onCopy: onCopy,
          appTheme: appTheme,
          address: address,
          accountName: accountName,
        ),
      ),
    );
  }
}

// Define a class named AccountCardReceiveWidget
class AccountCardReceiveWidget extends StatelessWidget {
  final void Function(String) onCopy;
  final AppTheme appTheme;
  final String accountName;
  final String address;

  const AccountCardReceiveWidget({
    required this.onCopy,
    required this.accountName,
    required this.address,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCopy(address),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.spacing04,
          vertical: Spacing.spacing05,
        ),
        decoration: BoxDecoration(
          color: appTheme.surfaceColorGrayLight,
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadius05,
          ),
        ),
        child: _HomeAccountReceiveWidget(
          appTheme: appTheme,
          address: address,
          accountName: accountName,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/aura_smart_account_base_widget.dart';
import 'package:domain/domain.dart';

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

  @override
  Widget actionFormBuilder(BuildContext context) {
    if (account.isSmartAccount) {
      return Container();
    }
    return const SizedBox.shrink();
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


final class _HomeAccountWidget extends AuraSmartAccountBaseWidget {
  final VoidCallback onShowMoreAccount;
  final void Function(String) onCopy;

  const _HomeAccountWidget({
    required this.onShowMoreAccount,
    required this.onCopy,
    required super.appTheme,
    required super.address,
    required super.accountName,
    super.key,
  });

  @override
  Widget accountNameBuilder(BuildContext context) {
    return Row(
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
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onCopy(
            address,
          ),
          child: SvgPicture.asset(
            AssetIconPath.homeCopy,
          ),
        ),
      ],
    );
  }

  @override
  Widget actionFormBuilder(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onShowMoreAccount,
      child: SvgPicture.asset(
        AssetIconPath.homeArrowDown,
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

final class _HomeAccountReceiveWidget extends AuraSmartAccountBaseWidget {
  final void Function(String) onCopy;

  const _HomeAccountReceiveWidget({
    required this.onCopy,
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
    return const SizedBox();
  }

  @override
  Widget addressBuilder(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          address.addressView,
          style: AppTypoGraPhy.body02.copyWith(
            color: appTheme.contentColor700,
          ),
        ),
        const SizedBox(
          width: BoxSize.boxSize04,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onCopy(
            address,
          ),
          child: SvgPicture.asset(
            AssetIconPath.homeReceiveCopyAddress,
          ),
        )
      ],
    );
  }

  @override
  Widget avatarBuilder(BuildContext context) {
    return SvgPicture.asset(
      AssetIconPath.commonSmartAccountAvatarDefault,
    );
  }
}

/// region home account card
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
    return Container(
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
        onShowMoreAccount: onShowMoreAccount,
        onCopy: onCopy,
        appTheme: appTheme,
        address: address,
        accountName: accountName,
      ),
    );
  }
}

///endregion

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
    return Container(
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
        onCopy: onCopy,
        appTheme: appTheme,
        address: address,
        accountName: accountName,
      ),
    );
  }
}

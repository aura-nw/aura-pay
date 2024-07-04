import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/core/utils/context_extension.dart';
import 'package:pyxis_v2/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_v2/src/presentation/screens/generate_wallet/generate_wallet_creen.dart';

abstract class GenerateWalletMessageWidget extends StatelessWidget {
  final AppTheme appTheme;

  const GenerateWalletMessageWidget({
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing05,
        vertical: Spacing.spacing04,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(
            BorderRadiusSize.borderRadius03,
          ),
          topRight: Radius.circular(
            BorderRadiusSize.borderRadius04,
          ),
          bottomLeft: Radius.circular(
            BorderRadiusSize.borderRadius04,
          ),
          bottomRight: Radius.circular(
            BorderRadiusSize.borderRadius03,
          ),
        ),
        color: appTheme.bgPrimary,
      ),
      child: child(context),
    );
  }

  Widget child(BuildContext context);
}

final class GenerateWalletTextMessageWidget
    extends GenerateWalletMessageWidget {
  final String text;

  const GenerateWalletTextMessageWidget({
    required super.appTheme,
    required this.text,
    super.key,
  });

  @override
  Widget child(BuildContext context) {
    return Text(
      text,
      style: AppTypoGraPhy.textSmRegular.copyWith(
        color: appTheme.textPrimary,
      ),
      textAlign: TextAlign.start,
    );
  }
}

final class GenerateWalletAddressMessageWidget
    extends GenerateWalletMessageWidget {
  final String text;
  final String address;
  final VoidCallback? opCopy;

  const GenerateWalletAddressMessageWidget({
    required super.appTheme,
    required this.text,
    required this.address,
    this.opCopy,
    super.key,
  });

  @override
  Widget child(BuildContext context) {
    return GestureDetector(
      onTap: opCopy,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: AppTypoGraPhy.textSmRegular.copyWith(
              color: appTheme.textPrimary,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: BoxSize.boxSize04,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing03,
              vertical: Spacing.spacing02,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                BorderRadiusSize.borderRadius03,
              ),
              color: appTheme.bgSecondary,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    address.addressView,
                  ),
                ),
                const SizedBox(
                  width: BoxSize.boxSize04,
                ),
                SvgPicture.asset(
                  AssetIconPath.icCommonCopy,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class GenerateWalletYetiBotMessageWidget extends StatelessWidget {
  final AppTheme appTheme;
  final GenerateMessageObject messageObject;
  final int? nextGroup;
  final VoidCallback? onTap;

  const GenerateWalletYetiBotMessageWidget({
    required this.appTheme,
    required this.messageObject,
    this.nextGroup,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildAvtGroup(),
        const SizedBox(
          width: BoxSize.boxSize04,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.w * 0.65,
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildAvtGroup() {
    if (messageObject.groupId != nextGroup) {
      return SvgPicture.asset(
        AssetImagePath.yetiBot,
      );
    }

    return const SizedBox(
      width: BoxSize.boxSize08,
      height: BoxSize.boxSize08,
    );
  }

  Widget buildMessage() {
    // If need many cases. Use type for detection.
    if (messageObject.isTextMessage) {
      return GenerateWalletTextMessageWidget(
        appTheme: appTheme,
        text: messageObject.data,
      );
    }

    return GenerateWalletAddressMessageWidget(
      appTheme: appTheme,
      text: messageObject.data,
      address: messageObject.object.toString(),
      opCopy: onTap,
    );
  }
}

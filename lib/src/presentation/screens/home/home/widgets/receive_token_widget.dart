import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_view_widget.dart';
import 'account_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveTokenWidget extends StatelessWidget {
  final String address;
  final String accountName;
  final AppTheme theme;
  final VoidCallback onSwipeUp;
  final VoidCallback onShareAddress;
  final void Function(String) onCopyAddress;

  const ReceiveTokenWidget({
    required this.accountName,
    required this.address,
    required this.theme,
    required this.onSwipeUp,
    required this.onShareAddress,
    required this.onCopyAddress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Triggered when a vertical drag gesture ends
      onVerticalDragEnd: (dragDetail) {
        if (dragDetail.velocity.pixelsPerSecond.dy < -50) {
          onSwipeUp.call();
        }
      },
      // Triggered when the widget is tapped
      onTap: () {
        onSwipeUp.call();
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          // Overlay color with opacity
          color: theme.bodyColorOverlay.withOpacity(0.8),
          width: context.w,
          height: context.h,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.spacing09,
          ),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.only(
                left: Spacing.spacing05,
                right: Spacing.spacing05,
                bottom: Spacing.spacing07,
                top: Spacing.spacing04,
              ),
              decoration: BoxDecoration(
                color: theme.bodyColorBackground,
                borderRadius: BorderRadius.circular(
                  BorderRadiusSize.borderRadius06,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Scrollable view widget
                  ScrollViewWidget(
                    appTheme: theme,
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize08,
                  ),
                  // QR code image view
                  QrImageView(
                    data: address,
                    version: QrVersions.auto,
                    padding: EdgeInsets.zero,
                    backgroundColor: theme.bodyColorBackground,
                    size: context.w / 2.4,
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize06,
                  ),
                  // Account card receive widget
                  AccountCardReceiveWidget(
                    onCopy: (address) => onCopyAddress(address),
                    accountName: accountName,
                    address: address,
                    appTheme: theme,
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize07,
                  ),
                  // App localization provider
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return PrimaryAppButton(
                        leading: SvgPicture.asset(
                          AssetIconPath.homeReceiveShareAddress,
                        ),
                        text: localization.translate(
                          LanguageKey.homePageReceiveShareAddress,
                        ),
                        onPress: onShareAddress,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

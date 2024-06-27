import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';

abstract class AuraSmartAccountBaseWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String accountName;
  final String address;

  const AuraSmartAccountBaseWidget({
    super.key,
    required this.appTheme,
    required this.address,
    required this.accountName,
  });

  Widget avatarBuilder(BuildContext context);

  Widget accountNameBuilder(BuildContext context);

  Widget addressBuilder(BuildContext context);

  Widget actionFormBuilder(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        avatarBuilder(
          context,
        ),
        const SizedBox(
          width: BoxSize.boxSize05,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              accountNameBuilder(
                context,
              ),
              const SizedBox(
                height: BoxSize.boxSize02,
              ),
              addressBuilder(
                context,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: BoxSize.boxSize05,
        ),
        actionFormBuilder(
          context,
        ),
      ],
    );
  }
}

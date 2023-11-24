import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';

class AccountCardWidget extends StatelessWidget {
  final String accountName;
  final String address;

  const AccountCardWidget({
    required this.address,
    required this.accountName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BorderRadiusSize.borderRadius04),
      ),
    );
  }
}

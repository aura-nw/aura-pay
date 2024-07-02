import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
mixin StatelessBaseScreen on StatelessWidget {
  Widget buildSpace(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.spacing05,
          horizontal: Spacing.spacing07,
        ),
        child: child(context),
      ),
    );
  }

  Widget child(BuildContext context);

  Widget wrapBuild(BuildContext context, Widget child);

  @override
  Widget build(BuildContext context) {
    return wrapBuild(
      context,
      buildSpace(context),
    );
  }
}

mixin StateFulBaseScreen<T extends StatefulWidget> on State<T>{

  Widget buildSpace(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.spacing05,
          horizontal: Spacing.spacing07,
        ),
        child: child(context),
      ),
    );
  }

  Widget child(BuildContext context);

  Widget wrapBuild(BuildContext context, Widget child);

  @override
  Widget build(BuildContext context) {
    return wrapBuild(
      context,
      buildSpace(context),
    );
  }
}

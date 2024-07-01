import 'package:flutter/material.dart';

mixin StatelessBaseScreen on StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return child(context);
  }

  Widget child(BuildContext context);
}

mixin StateFulBaseScreen<T extends StatefulWidget> on State<T>{
  @override
  Widget build(BuildContext context) {
    return child(context);
  }

  Widget child(BuildContext context);
}
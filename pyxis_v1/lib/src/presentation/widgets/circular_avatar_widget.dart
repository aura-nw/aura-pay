import 'package:flutter/material.dart';

class CircularAvatarWidget extends StatefulWidget {
  final ImageProvider? image;
  final Color? backgroundColor;
  final double borderWidth;
  final double radius;

  const CircularAvatarWidget({
    Key? key,
    required this.image,
    required this.radius,
    TextStyle? textStyle,
    this.borderWidth = 1,
    this.backgroundColor,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CircularAvatarWidgetState createState() => _CircularAvatarWidgetState();
}

class _CircularAvatarWidgetState extends State<CircularAvatarWidget> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _prepareImage();
  }

  @override
  void didUpdateWidget(covariant CircularAvatarWidget oldWidget) {
    if (oldWidget.image != widget.image) {
      _prepareImage();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _prepareImage() {
    if (widget.image == null) return;

    widget.image!
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((info, mounted) {
      if (mounted) {
        setState(
          () => _loading = false,
        );
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? CircleAvatar(
            backgroundColor: widget.backgroundColor,
            radius: widget.radius - widget.borderWidth,
          )
        : CircleAvatar(
            backgroundColor: widget.backgroundColor,
            backgroundImage: widget.image,
            radius: widget.radius - widget.borderWidth,
          );
  }
}

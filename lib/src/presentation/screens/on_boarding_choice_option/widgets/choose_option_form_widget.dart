import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';

class ChooseOptionWidget extends StatelessWidget {
  final String title;
  final String content;
  final AppTheme appTheme;
  final VoidCallback onTap;

  const ChooseOptionWidget({
    required this.title,
    required this.content,
    required this.appTheme,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize02,
                ),
                Text(
                  content,
                  style: AppTypoGraPhy.body02.copyWith(
                    color: appTheme.contentColor500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: BoxSize.boxSize05,
          ),
          SvgPicture.asset(
            AssetIconPath.commonArrowNext,
          ),
        ],
      ),
    );
  }
}

class ChooseOptionFormWidget extends AppBottomSheetBase {
  final List<ChooseOptionWidget> children;

  const ChooseOptionFormWidget({
    required this.children,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ChooseOptionFormWidgetState();
}

class _ChooseOptionFormWidgetState
    extends AppBottomSheetBaseState<ChooseOptionFormWidget> {
  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return const SizedBox.shrink();
  }

  @override
  Widget contentBuilder(BuildContext context, AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        Column(
          children: List.generate(widget.children.length, (index) {
            final Widget option = widget.children[index];
            return Column(
              children: [
                option,
                if (index != widget.children.length - 1) ...[
                  const SizedBox(
                    height: BoxSize.boxSize05,
                  ),
                  const HoLiZonTalDividerWidget(),
                  const SizedBox(
                    height: BoxSize.boxSize05,
                  ),
                ]
              ],
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget bottomBuilder(BuildContext context, AppTheme appTheme) {
    return const SizedBox.shrink();
  }

  @override
  Widget subTitleBuilder(BuildContext context, AppTheme appTheme) {
    return const SizedBox.shrink();
  }
}

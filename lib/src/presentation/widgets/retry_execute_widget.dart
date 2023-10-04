// import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
// import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
// import 'package:pyxis_mobile/src/core/constants/language_key.dart';
// import 'package:pyxis_mobile/src/core/constants/typography.dart';
// import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
// import 'package:flutter/material.dart';
//
// class RetryExecuteWidget extends StatelessWidget {
//   final VoidCallback onRetry;
//
//   const RetryExecuteWidget({required this.onRetry, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         AppThemeBuilder(
//           builder: (theme) {
//             return AppLocalizationProvider(
//               builder: (language, _) {
//                 return AppButton(
//                   text: language.translate(LanguageKey.commonWidgetButtonRetry),
//                   color: theme.neutralColor21,
//                   textStyle:
//                       AppTypoGraPhy.button16.copyWith(color: theme.lightColor),
//                   onPress: onRetry,
//                 );
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

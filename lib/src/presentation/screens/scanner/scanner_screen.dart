import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/helpers/image_picker_helper.dart';
import 'package:pyxis_mobile/src/core/helpers/system_permission_helper.dart';
import 'package:pyxis_mobile/src/presentation/screens/scanner/widgets/scanner_app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/scanner/widgets/scanner_overlay.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    autoStart: true,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          body: Stack(
            children: [
              MobileScanner(
                onDetect: (barcodeCapture) async {
                  if (barcodeCapture.barcodes.isEmpty) return;

                  await _controller.stop();

                  final barcode = barcodeCapture.barcodes[0];

                  AppNavigator.pop(
                    barcode.rawValue,
                  );
                },
                controller: _controller,
                errorBuilder: (_, exception, child) {
                  return const SizedBox.shrink();
                },
                fit: BoxFit.cover,
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: ScannerOverLayShape(
                    borderColor: appTheme.borderColorWhite,
                    overlayColor: appTheme.surfaceColorBlack.withOpacity(
                      0.5,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: ScannerAppBarWidget(
                  appTheme: appTheme,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    _showRequestCameraPermission(
                      appTheme,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacing04,
                      vertical: Spacing.spacing03,
                    ),
                    margin: const EdgeInsets.only(
                      bottom: BoxSize.boxSize11,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: appTheme.borderColorWhite,
                      ),
                      borderRadius: BorderRadius.circular(
                        BorderRadiusSize.borderRadius06,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AssetIconPath.scannerPhoto,
                        ),
                        const SizedBox(
                          width: BoxSize.boxSize03,
                        ),
                        AppLocalizationProvider(
                          builder: (localization, _) {
                            return Text(
                              localization.translate(
                                localization.translate(
                                  LanguageKey.scannerScreenUploadPhoto,
                                ),
                              ),
                              style: AppTypoGraPhy.bodyMedium03.copyWith(
                                color: appTheme.contentColorWhite,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openScan()async{
    final String? path = await ImagePickerHelper.pickSingleImage();

    if (path == null) return;

    await _controller.analyzeImage(path);
  }

  void _showRequestCameraPermission(AppTheme appTheme) async{

    PermissionStatus status = await SystemPermissionHelper.getCurrentPhotoPermissionStatus();

    if(status.isGranted){
      _openScan();
    }else{
      if(context.mounted){
        DialogProvider.showPermissionDialog(
          context,
          appTheme: appTheme,
          onAccept: () {
            AppNavigator.pop();

            SystemPermissionHelper.requestPhotoPermission(
              onSuccessFul: _openScan,
              reject: () {
                SystemPermissionHelper.goToSettings();
              },
            );
          },
          headerIconPath: AssetIconPath.commonPermissionGallery,
          titleKey: LanguageKey.commonPermissionGalleryTitle,
          contentKey: LanguageKey.commonPermissionGalleryContent,
        );
      }
    }
  }
}

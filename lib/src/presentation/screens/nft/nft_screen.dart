import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/screens/nft/nft_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'nft_bloc.dart';
import 'nft_event.dart';
import 'nft_state.dart';
import 'widgets/nft_layout_builder.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

import 'widgets/nft_count_widget.dart';

class NFTScreen extends StatefulWidget {
  const NFTScreen({super.key});

  @override
  State<NFTScreen> createState() => _NFTScreenState();
}

class _NFTScreenState extends State<NFTScreen>
    with SingleTickerProviderStateMixin {
  final NFTBloc _bloc = getIt.get<NFTBloc>();
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _opacityController = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(
        milliseconds: 1200,
      ),
      reverseDuration: const Duration(
        milliseconds: 1200,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0, // Starting opacity
      end: 1.0, // Ending opacity
    ).animate(_opacityController);

    _bloc.add(
      const NFTEventOnInit(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<NFTBloc, NFTState>(
            listener: (context, state) async {
              if (state.status == NFTStatus.onChangeViewType) {
                if (_opacityController.isCompleted) {
                  await _opacityController.reverse();

                  _opacityController.reset();
                }
              }
            },
            child: Scaffold(
              backgroundColor: appTheme.bodyColorBackground,
              appBar: AppBarWithTitle(
                appTheme: appTheme,
                titleKey: LanguageKey.nftScreenAppBarTitle,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing05,
                ),
                child: NFTStatusSelector(
                  builder: (status) {
                    switch (status) {
                      case NFTStatus.loading:
                        return Center(
                          child: AppLoadingWidget(
                            appTheme: appTheme,
                          ),
                        );
                      case NFTStatus.error:
                      case NFTStatus.loaded:
                      case NFTStatus.refresh:
                      case NFTStatus.loadMore:
                      case NFTStatus.onChangeViewType:
                        return Column(
                          children: [
                            NFTCountWidget(
                              appTheme: appTheme,
                              onChangeViewType: () async {
                                await _opacityController.forward();
                              },
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize07,
                            ),
                            Expanded(
                              child: NFTLayoutBuilder(
                                appTheme: appTheme,
                                opacityAnimation: _opacityAnimation,
                              ),
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

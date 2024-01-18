import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/provider/wallet_connect/wallet_connect_service.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

// Enum defining various states of WalletConnectScreen
enum WalletConnectScreenState {
  empty,
  onLoading,
  onRequestConnecting,
  onRequestSign,
  listData,
}

class WalletConnectScreenData {
  final String url;
  final String selectedAccount;

  WalletConnectScreenData({required this.url, required this.selectedAccount});
}

class WalletConnectScreen extends StatefulWidget {
  final WalletConnectScreenData data;

  const WalletConnectScreen({super.key, required this.data});

  @override
  State<WalletConnectScreen> createState() => _WalletConnectScreenState();
}

class _WalletConnectScreenState extends State<WalletConnectScreen> {
  // Suppose you have a list of connected dApps
  List<String> connectedDApps = ['DApp 1', 'DApp 2', 'DApp 3'];

  WalletConnectService _walletConnectService = GetIt.I.get();

  // Variable to track the current state of the screen
  WalletConnectScreenState _screenState = WalletConnectScreenState.onLoading;

  SessionProposalEvent? _sessionProposalEvent;
  int? connectionId;

  @override
  void initState() {
    super.initState();
    _onConnect();
  }

  // onConnect
  Future<void> _onConnect() async {
    await Future.delayed(Durations.long1);
    try {
      final Uri uriData = Uri.parse(widget.data.url);
      _walletConnectService.getWeb3Wallet().onSessionProposal.subscribe((args) {
        print('WalletConnectScreen _onConnect onSessionProposal: $args');
        _sessionProposalEvent = args;
        connectionId = _sessionProposalEvent?.id;
        setState(() {
          _screenState = WalletConnectScreenState.onRequestConnecting;
        });
      });
      await _walletConnectService.getWeb3Wallet().pair(
            uri: uriData,
          );
    } catch (e, s) {
      print('WalletConnectScreen _onConnect error: $e, $s');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(builder: (appTheme) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: _buildBody(appTheme),
      );
    });
  }

  // Method to build the content of the screen based on the state
  Widget _buildBody(AppTheme appTheme) {
    switch (_screenState) {
      case WalletConnectScreenState.empty:
        return _buildEmptyState();
      case WalletConnectScreenState.onLoading:
        return _buildLoadingState();
      case WalletConnectScreenState.onRequestConnecting:
        return _buildRequestConnectingState(
            appTheme, _sessionProposalEvent?.params);
      case WalletConnectScreenState.onRequestSign:
        return _buildRequestSignState();
      case WalletConnectScreenState.listData:
        return _buildListDataState();
      default:
        return Container(); // Default case
    }
  }

  // Method to build UI for empty state
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('DApp Connected will be here'),
          Text('Empty list'),
        ],
      ),
    );
  }

  // Method to build UI for loading state
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Method to build UI for connecting request state
  Widget _buildRequestConnectingState(
      AppTheme appTheme, ProposalData? proposalData) {
    if (true) {
      return AppLocalizationProvider(
        builder: (localization, _) {
          return Padding(
            padding: const EdgeInsets.all(
              Spacing.spacing04,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  localization.translate(LanguageKey.walletConnectHeadTitle),
                  style: AppTypoGraPhy.heading02
                      .copyWith(color: appTheme.contentColorBlack),
                ),
                const SizedBox(
                  height: BoxSize.boxSize02,
                ),
                Text(
                  '${proposalData?.proposer.metadata.url}',
                  style: AppTypoGraPhy.body02
                      .copyWith(color: appTheme.contentColor500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: BoxSize.boxSize04,
                ),
                Text(
                  localization.translate(LanguageKey.walletConnectWarningMsg),
                  style: AppTypoGraPhy.body02
                      .copyWith(color: appTheme.contentColor500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: BoxSize.boxSize05,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    localization.translate(LanguageKey.walletConnectMessage),
                    style: AppTypoGraPhy.utilityLabelDefault
                        .copyWith(color: appTheme.contentColorBlack),
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize04,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing05,
                    vertical: Spacing.spacing04,
                  ),
                  margin: const EdgeInsets.only(
                    bottom: BoxSize.boxSize08,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      BorderRadiusSize.borderRadius04,
                    ),
                    color: appTheme.surfaceColorGrayDefault,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AssetIconPath.commonSignMessage,
                      ),
                      const SizedBox(
                        width: BoxSize.boxSize05,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.translate(
                                LanguageKey.walletConnectSignIn,
                              ),
                              style: AppTypoGraPhy.bodyMedium03.copyWith(
                                color: appTheme.contentColorBlack,
                              ),
                            ),
                            RichText(
                              maxLines: 3,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: localization.translate(
                                      LanguageKey.walletConnectSignIn,
                                    ),
                                    style: AppTypoGraPhy.bodyMedium02.copyWith(
                                      color: appTheme.contentColor500,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' ${widget.data.selectedAccount.addressView} ',
                                    style: AppTypoGraPhy.body02.copyWith(
                                      color: appTheme.contentColor500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: localization
                                        .translate(LanguageKey.walletConnecTo),
                                    style: AppTypoGraPhy.bodyMedium02.copyWith(
                                      color: appTheme.contentColor500,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' ${proposalData?.proposer.metadata.url}',
                                    style: AppTypoGraPhy.body02.copyWith(
                                      color: appTheme.contentColor500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                PrimaryAppButton(
                  text: localization.translate(
                    LanguageKey.walletConnectSignIn,
                  ),
                  onPress: _approveConnection,
                ),
                const SizedBox(
                  height: BoxSize.boxSize05,
                ),
                BorderAppButton(
                  text: localization.translate(
                    LanguageKey.walletConnecReject,
                  ),
                  onPress: _rejectConnection,
                  borderColor: appTheme.borderColorGrayDark,
                  textColor: appTheme.contentColorBlack,
                ),
              ],
            ),
          );
        },
      );
    }
  }

  // Method to build UI for sign request state
  Widget _buildRequestSignState() {
    return Container();
  }

  // Method to build UI for connected dApp list state
  Widget _buildListDataState() {
    return ListView.builder(
      itemCount: connectedDApps.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('DApp: ${connectedDApps[index]}'),
          subtitle: const Text('Subtitle'),
          // TODO: Add handling when a connected dApp is tapped
          onTap: () {
            // Handle when a dApp is tapped
          },
        );
      },
    );
  }

  Future<void> _approveConnection() async {
    setState(() {
      _screenState = WalletConnectScreenState.onLoading;
    });
    await _walletConnectService
        .getWeb3Wallet()
        .approveSession(id: connectionId!, namespaces: {
      'cosmos': Namespace(accounts: [
        'cosmos:euphoria-2:${widget.data.selectedAccount}',
        'cosmos:cosmoshub-4:${widget.data.selectedAccount}',
        'cosmos:xstaxy-1:${widget.data.selectedAccount}',
      ], methods: [
        'cosmos_signDirect',
        'cosmos_getAccounts',
        'cosmos_signAmino'
      ], events: [
        'chainChanged',
        'accountsChanged'
      ]),
    });

    AppNavigator.pop();
  }

  Future<void> _rejectConnection() async {
    setState(() {
      _screenState = WalletConnectScreenState.onLoading;
    });
    await _walletConnectService.getWeb3Wallet().rejectSession(
          id: connectionId!,
          reason: Errors.getSdkError(Errors.USER_REJECTED),
        );

    AppNavigator.pop();
  }
}

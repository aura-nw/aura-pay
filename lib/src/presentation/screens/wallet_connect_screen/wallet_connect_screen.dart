import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/provider/wallet_connect/wallet_connect_service.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

// Enum định nghĩa các trạng thái khác nhau của WalletConnectScreen
enum WalletConnectScreenState {
  empty,
  onLoading,
  onRequestConnecting,
  onRequestSign,
  listData,
}

class WalletConnectScreen extends StatefulWidget {
  final String url;

  const WalletConnectScreen({super.key, required this.url});

  @override
  State<WalletConnectScreen> createState() => _WalletConnectScreenState();
}

class _WalletConnectScreenState extends State<WalletConnectScreen> {
  // Giả sử rằng bạn có một danh sách các dApp đã kết nối
  List<String> connectedDApps = ['DApp 1', 'DApp 2', 'DApp 3'];

  WalletConnectService _walletConnectService = GetIt.I.get();

  // Biến để theo dõi trạng thái hiện tại của màn hình
  WalletConnectScreenState _screenState =
      WalletConnectScreenState.onRequestConnecting;

  SessionProposalEvent? _sessionProposalEvent;
  int? connectionId;

  @override
  void initState() {
    super.initState();
    _onConnect();
  }

  // onConnect
  Future<void> _onConnect() async {
    // await Future.delayed(Durations.long1);
    // try {
    //   final Uri uriData = Uri.parse(widget.url);
    //   _walletConnectService.getWeb3Wallet().onSessionProposal.subscribe((args) {
    //     print('WalletConnectScreen _onConnect onSessionProposal: $args');
    //     _sessionProposalEvent = args;
    //     connectionId = _sessionProposalEvent?.id;
    //     setState(() {
    //       _screenState = WalletConnectScreenState.onRequestConnecting;
    //     });
    //   });
    //   await _walletConnectService.getWeb3Wallet().pair(
    //         uri: uriData,
    //       );
    // } catch (e, s) {
    //   print('WalletConnectScreen _onConnect error: $e, $s');
    // }
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

  // Phương thức để xây dựng nội dung của màn hình dựa trên trạng thái
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
        return Container(); // Trường hợp mặc định
    }
  }

  // Phương thức xây dựng UI cho trạng thái rỗng
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('DApp Connected will be here'),
          Text('Danh sách rỗng'),
        ],
      ),
    );
  }

  // Phương thức xây dựng UI cho trạng thái đang tải
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Phương thức xây dựng UI cho trạng thái yêu cầu kết nối
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
                  'Title: ${proposalData?.proposer.metadata.url}',
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
                    'Messages',
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localization.translate(
                              LanguageKey.commonSignIn,
                            ),
                            style: AppTypoGraPhy.bodyMedium03.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: localization.translate(
                                    LanguageKey.commonSignIn,
                                  ),
                                  style: AppTypoGraPhy.bodyMedium02.copyWith(
                                    color: appTheme.contentColor500,
                                  ),
                                ),
                                TextSpan(
                                  text: '[account address]',
                                  style: AppTypoGraPhy.body02.copyWith(
                                    color: appTheme.contentColor500,
                                  ),
                                ),
                                TextSpan(
                                  text: 'to',
                                  style: AppTypoGraPhy.bodyMedium02.copyWith(
                                    color: appTheme.contentColor500,
                                  ),
                                ),
                                TextSpan(
                                  text: '[URL Dapp]',
                                  style: AppTypoGraPhy.body02.copyWith(
                                    color: appTheme.contentColor500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                PrimaryAppButton(
                  text: localization.translate(
                    LanguageKey.commonSignIn,
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize05,
                ),
                BorderAppButton(
                  text: 'Cancel',
                  borderColor: appTheme.borderColorGrayDark,
                  textColor: appTheme.contentColorBlack,
                ),
              ],
            ),
          );
        },
      );
    }

    if (proposalData == null) {
      return const Text('proposalData Empty');
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Yêu cầu kết nối',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Title: ${proposalData.proposer.metadata.name}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Description: ${proposalData.proposer.metadata.description}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'URL: ${proposalData.proposer.metadata.url}',
          style: const TextStyle(fontSize: 16),
        ),
        // ...Thêm thông tin khác cần hiển thị

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn vào Approve
                _approveConnection();
              },
              child: const Text('Approve'),
            ),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn vào Reject
                _rejectConnection();
              },
              child: const Text('Reject'),
            ),
          ],
        ),
      ],
    );
  }

  // Phương thức xây dựng UI cho trạng thái yêu cầu ký giao dịch
  Widget _buildRequestSignState() {
    return Container();
  }

  // Phương thức xây dựng UI cho trạng thái danh sách dApp đã kết nối
  Widget _buildListDataState() {
    return ListView.builder(
      itemCount: connectedDApps.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('DApp: ${connectedDApps[index]}'),
          subtitle: const Text('Subtitle'),
          // TODO: Thêm xử lý khi nhấn vào một dApp đã kết nối
          onTap: () {
            // Xử lý khi nhấn vào một dApp
          },
        );
      },
    );
  }

  void _approveConnection() {
    _walletConnectService
        .getWeb3Wallet()
        .approveSession(id: connectionId!, namespaces: {
      'cosmos': const Namespace(accounts: [
        'cosmos:euphoria-2:aura1k70ltrdhpx97va9ggm5us3kq3avrmh9pfurz7l',
        'cosmos:cosmoshub-4:aura1k70ltrdhpx97va9ggm5us3kq3avrmh9pfurz7l'
      ], methods: [
        'cosmos_signDirect',
        'cosmos_getAccounts',
        'cosmos_signAmino'
      ], events: [
        'chainChanged',
        'accountsChanged'
      ]),
    });
  }

  void _rejectConnection() {}
}

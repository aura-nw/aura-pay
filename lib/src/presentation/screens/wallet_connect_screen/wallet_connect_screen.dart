import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pyxis_mobile/src/application/provider/wallet_connect/wallet_connect_service.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/sign_client_events.dart';
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
  WalletConnectScreenState _screenState = WalletConnectScreenState.empty;

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
      final Uri uriData = Uri.parse(widget.url);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Connection Details'),
      ),
      body: _buildBody(),
    );
  }

  // Phương thức để xây dựng nội dung của màn hình dựa trên trạng thái
  Widget _buildBody() {
    switch (_screenState) {
      case WalletConnectScreenState.empty:
        return _buildEmptyState();
      case WalletConnectScreenState.onLoading:
        return _buildLoadingState();
      case WalletConnectScreenState.onRequestConnecting:
        return _buildRequestConnectingState(_sessionProposalEvent?.params);
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
    return Center(
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
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // Phương thức xây dựng UI cho trạng thái yêu cầu kết nối
  Widget _buildRequestConnectingState(ProposalData? proposalData) {
    if (proposalData == null) {
      return Text('proposalData Empty');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Yêu cầu kết nối',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Title: ${proposalData.proposer.metadata.name}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Description: ${proposalData.proposer.metadata.description}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'URL: ${proposalData.proposer.metadata.url}',
          style: TextStyle(fontSize: 16),
        ),
        // ...Thêm thông tin khác cần hiển thị

        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn vào Approve
                _approveConnection();
              },
              child: Text('Approve'),
            ),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn vào Reject
                _rejectConnection();
              },
              child: Text('Reject'),
            ),
          ],
        ),
      ],
    );
  }

  // Phương thức xây dựng UI cho trạng thái yêu cầu ký giao dịch
  Widget _buildRequestSignState() {
    // TODO: Thêm mã nguồn để xây dựng giao diện cho trạng thái này
    return Container();
  }

  // Phương thức xây dựng UI cho trạng thái danh sách dApp đã kết nối
  Widget _buildListDataState() {
    return ListView.builder(
      itemCount: connectedDApps.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('DApp: ${connectedDApps[index]}'),
          subtitle: Text('Subtitle'),
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

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Connection Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // App title
//             Text(
//               'HaloTrade wants to connect to your wallet',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             // Wallet address
//             Row(
//               children: [
//                 Text('Wallet address: '),
//                 Text('staging.halotrade.zone'),
//               ],
//             ),

//             // Wallet connection status
//             Row(
//               children: [
//                 Text('Connecting to Wallet 1: '),
//                 Text('aural...umdöv'),
//               ],
//             ),

//             // Permissions
//             Text(
//               'HaloTrade will be able to:',
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Column(
//               children: [
//                 // View wallet balance and activity
//                 Row(
//                   children: [
//                     Text('View wallet balance and activity'),
//                   ],
//                 ),

//                 // Request approval for transactions
//                 Row(
//                   children: [
//                     Text('Request approval for transactions'),
//                   ],
//                 ),
//               ],
//             ),

//             // Connect button
//             Container(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: Text('Connect'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

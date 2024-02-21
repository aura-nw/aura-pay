import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_cubit.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_state.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class WalletConnectOnConnectScreen extends StatefulWidget {
  final ConnectingData connectingData;

  const WalletConnectOnConnectScreen({
    Key? key,
    required this.connectingData,
  }) : super(key: key);

  @override
  State<WalletConnectOnConnectScreen> createState() =>
      _WalletConnectOnConnectScreenState();
}

class _WalletConnectOnConnectScreenState
    extends State<WalletConnectOnConnectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Connect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Connecting to ${widget.connectingData.account}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Image.network(
              widget.connectingData.logo,
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 16),
            Text(
              'Account: ${widget.connectingData.account}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'URL: ${widget.connectingData.urlConnect}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            PrimaryAppButton(
              text: 'Connect',
              onPress: () {
                WalletConnectCubit.of(context)
                    .approveConnection(widget.connectingData);
              },
            ),
          ],
        ),
      ),
    );
  }
}

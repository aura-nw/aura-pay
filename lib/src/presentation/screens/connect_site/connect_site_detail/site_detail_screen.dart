import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class SiteDetailScreen extends StatelessWidget {
  final SessionData sessionData;

  const SiteDetailScreen(this.sessionData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sessionData.peer.metadata.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(sessionData.peer.metadata.icons.first),
            Text(sessionData.peer.metadata.name),
            Text(sessionData.peer.metadata.url),
            ElevatedButton(
              onPressed: () async {
                // Handle disconnect action
                // Example:
                // disconnectSession();
                // WalletConnectService walletConnectService =
                //     GetIt.I.get<WalletConnectService>();
                // await walletConnectService.disconnectSession(sessionData);
                Navigator.pop(context);
              },
              child: Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:get_it/get_it.dart';
import 'package:pyxis_mobile/src/application/provider/wallet_connect/wc_connection_widget/wc_connection_model.dart';
import 'package:pyxis_mobile/src/application/provider/wallet_connect/wc_connection_widget/wc_connection_widget.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class ConnectionWidgetBuilder {
  static List<WCConnectionWidget> buildFromRequiredNamespaces(
    Map<String, Namespace> generatedNamespaces,
  ) {
    final List<WCConnectionWidget> views = [];
    for (final key in generatedNamespaces.keys) {
      Namespace ns = generatedNamespaces[key]!;
      final List<WCConnectionModel> models = [];
      // If the chains property is present, add the chain data to the models
      models.add(
        WCConnectionModel(
          title: "StringConstants.chains",
          elements: ns.accounts.map((acc) {
            return NamespaceUtils.getChainFromAccount(acc);
          }).toList(),
        ),
      );
      models.add(WCConnectionModel(
        title: "StringConstants.methods",
        elements: ns.methods,
      ));
      models.add(WCConnectionModel(
        title: "StringConstants.events",
        elements: ns.events,
      ));

      views.add(
        WCConnectionWidget(
          title: key,
          info: models,
        ),
      );
    }

    return views;
  }

  static List<WCConnectionWidget> buildFromNamespaces(
    String topic,
    Map<String, Namespace> namespaces,
  ) {
    final List<WCConnectionWidget> views = [];
    for (final key in namespaces.keys) {
      final Namespace ns = namespaces[key]!;
      final List<WCConnectionModel> models = [];
      // If the chains property is present, add the chain data to the models
      models.add(
        WCConnectionModel(
          title: 'StringConstants.chains',
          elements: ns.accounts,
        ),
      );
      models.add(WCConnectionModel(
        title: 'StringConstants.methods',
        elements: ns.methods,
      ));

      Map<String, void Function()> actions = {};
      for (final String event in ns.events) {
        actions[event] = () async {
          print('# KhoaHM NameSpaceModelBuilder emitSessionEvent $event ');
          // final String chainId = NamespaceUtils.isValidChainId(key)
          //     ? key
          //     : NamespaceUtils.getChainFromAccount(ns.accounts.first);
          // await GetIt.I<IWeb3WalletService>().getWeb3Wallet().emitSessionEvent(
          //       topic: topic,
          //       chainId: chainId,
          //       event: SessionEventParams(
          //         name: event,
          //         data: 'Event: $event',
          //       ),
          //     );
        };
      }
      models.add(WCConnectionModel(
        title: 'StringConstants.events',
        elements: ns.events,
        elementActions: actions,
      ));

      views.add(
        WCConnectionWidget(
          title: key,
          info: models,
        ),
      );
    }

    return views;
  }
}

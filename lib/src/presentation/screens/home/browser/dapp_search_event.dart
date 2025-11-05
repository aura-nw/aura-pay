import 'package:aurapay/src/presentation/screens/home/browser/models/dapp_model.dart';

sealed class DAppSearchEvent {
  const DAppSearchEvent();
}

/// Event to initialize the search screen
final class DAppSearchOnInitEvent extends DAppSearchEvent {
  const DAppSearchOnInitEvent();
}

/// Event to handle search query changes
final class DAppSearchOnSearchEvent extends DAppSearchEvent {
  final String query;

  const DAppSearchOnSearchEvent(this.query);
}

/// Event to handle DApp visit
final class DAppSearchOnVisitEvent extends DAppSearchEvent {
  final DAppModel dapp;

  const DAppSearchOnVisitEvent(this.dapp);
}

/// Event to remove item from history
final class DAppSearchOnRemoveHistoryEvent extends DAppSearchEvent {
  final String dappId;

  const DAppSearchOnRemoveHistoryEvent(this.dappId);
}


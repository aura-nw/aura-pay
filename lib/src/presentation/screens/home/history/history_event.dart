sealed class HistoryEvent {
  const HistoryEvent();
}

/// Event to initialize the history screen and load transactions
final class HistoryOnInitEvent extends HistoryEvent {
  const HistoryOnInitEvent();
}

/// Event to handle search query changes
final class HistoryOnSearchEvent extends HistoryEvent {
  final String query;

  const HistoryOnSearchEvent(this.query);
}

/// Event to handle refresh transactions
final class HistoryOnRefreshEvent extends HistoryEvent {
  const HistoryOnRefreshEvent();
}


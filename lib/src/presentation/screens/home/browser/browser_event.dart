sealed class BrowserEvent {
  const BrowserEvent();
}

/// Event to initialize the browser screen and load DApps
final class BrowserOnInitEvent extends BrowserEvent {
  const BrowserOnInitEvent();
}

/// Event to handle search query changes
final class BrowserOnSearchEvent extends BrowserEvent {
  final String query;

  const BrowserOnSearchEvent(this.query);
}

/// Event to handle DApp visit
final class BrowserOnVisitDAppEvent extends BrowserEvent {
  final String dappId;
  final String url;

  const BrowserOnVisitDAppEvent(this.dappId, this.url);
}

/// Event to handle refresh
final class BrowserOnRefreshEvent extends BrowserEvent {
  const BrowserOnRefreshEvent();
}


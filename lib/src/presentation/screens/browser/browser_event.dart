import 'package:freezed_annotation/freezed_annotation.dart';

part 'browser_event.freezed.dart';

@freezed
class BrowserEvent with _$BrowserEvent {
  const factory BrowserEvent.onInit({
    required String url,
  }) = BrowserOnInitEvent;

  const factory BrowserEvent.onAddNewBrowser({
    required String url,
    required String siteName,
    required String logo,
  }) = BrowserOnAddNewBrowserEvent;

  const factory BrowserEvent.onBookMarkClick({
    required String name,
    required String url,
    required String logo,
    String? description,
  }) = BrowserOnBookMarkClickEvent;

  const factory BrowserEvent.onRefreshAccount() = BrowserOnRefreshAccountEvent;
}

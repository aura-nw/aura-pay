import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/presentation/screens/browser/browser_screen.dart';

part 'browser_event.freezed.dart';

@freezed
class BrowserEvent with _$BrowserEvent {
  const factory BrowserEvent.onInit() = BrowserOnInitEvent;

  const factory BrowserEvent.onUrlChangeEvent({
    required String url,
    String? title,
    String? logo,
    String? imagePath,
  }) = BrowserOnUrlChangeEvent;

  const factory BrowserEvent.onCheckBookMark({
    required String url,
    required bool canGoNext,
  }) = BrowserOnCheckBookMarkEvent;

  const factory BrowserEvent.onAddNewBrowser({
    required String url,
    required String siteName,
    required String logo,
    required String browserImage,
  }) = BrowserOnAddNewBrowserEvent;

  const factory BrowserEvent.onBookMarkClick({
    required String name,
    required String url,
    required String logo,
    String? description,
  }) = BrowserOnBookMarkClickEvent;

  const factory BrowserEvent.onRefreshAccount({
    required AuraAccount? selectedAccount,
  }) = BrowserOnRefreshAccountEvent;

  const factory BrowserEvent.onReceivedTabResult({
    required String url,
    required BrowserScreenOptionArgument option,
  }) = BrowserOnReceivedTabResultEvent;
}

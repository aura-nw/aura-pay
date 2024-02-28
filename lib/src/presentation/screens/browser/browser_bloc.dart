import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/screens/browser/browser_screen.dart';
import 'browser_event.dart';
import 'browser_state.dart';

class BrowserBloc extends Bloc<BrowserEvent, BrowserState> {
  final AuraAccountUseCase _auraAccountUseCase;
  final BrowserManagementUseCase _browserManagementUseCase;
  final BookMarkUseCase _bookMarkUseCase;

  BrowserBloc(
    this._auraAccountUseCase,
    this._browserManagementUseCase,
    this._bookMarkUseCase, {
    required BrowserScreenOptionArgument option,
    required String initUrl,
  }) : super(
          BrowserState(
            option: option,
            currentUrl: initUrl,
          ),
        ) {
    on(_onInit);
    on(_onUrlChangeEvent);
    on(_onBookMarkClick);
    on(_onAddNewBrowser);
    on(_onRefreshAccount);
    on(_onReceivedTabManagementResult);
  }

  void _onReceivedTabManagementResult(
    BrowserOnReceivedTabResultEvent event,
    Emitter<BrowserState> emit,
  ) async {
    await _browserManagementUseCase.update(
      id: event.option.choosingId!,
      url: event.url,
      logo: '',
      siteName: getSiteNameFromUrl(event.url),
      screenShotUri: '',
      isActive: true,
    );

    // Get all browsers
    final browsers = await _browserManagementUseCase.getBrowsers();

    emit(
      state.copyWith(
        option: event.option,
        currentUrl: event.url,
        currentBrowser: browsers.firstWhereOrNull(
          (e) => e.isActive,
        ),
        tabCount: browsers.length,
      ),
    );
  }

  void _onUrlChangeEvent(
    BrowserOnUrlChangeEvent event,
    Emitter<BrowserState> emit,
  ) async {
    final bookMark = await _bookMarkUseCase.getBookMarkByUrl(url: event.url);

    Browser ? currentBrowser = state.currentBrowser;

    if (currentBrowser != null) {
      currentBrowser = await _browserManagementUseCase.update(
        id: currentBrowser.id,
        url: event.url,
        logo: event.logo ?? currentBrowser.logo,
        siteName: event.title ?? currentBrowser.siteTitle,
        screenShotUri: event.imagePath ?? currentBrowser.screenShotUri,
        isActive: currentBrowser.isActive,
      );
    }

    if (bookMark == null) {
      emit(
        state.copyWithBookMarkNull(
          url: event.url,
          canGoNext: event.canGoNext,
        ),
      );
    } else {
      emit(
        state.copyWith(
          currentUrl: event.url,
          bookMark: bookMark,
          currentBrowser: currentBrowser,
        ),
      );
    }
  }

  void _onInit(
    BrowserOnInitEvent event,
    Emitter<BrowserState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BrowserStatus.loading,
      ),
    );

    final activeBrowser = await _getCurrentBrowser(
      url: state.currentUrl,
    );

    // Get all accounts
    final accounts = await _auraAccountUseCase.getAccounts();

    // Get all browsers
    final browsers = await _browserManagementUseCase.getBrowsers();

    emit(
      state.copyWith(
        accounts: accounts,
        tabCount: browsers.isEmpty ? 1 : browsers.length,
        status: BrowserStatus.loaded,
        currentBrowser: activeBrowser,
        selectedAccount: accounts.firstWhereOrNull(
          (e) => e.index == 0,
        ),
      ),
    );
  }

  void _onBookMarkClick(
    BrowserOnBookMarkClickEvent event,
    Emitter<BrowserState> emit,
  ) async {
    if (state.bookMark != null) {
      await _bookMarkUseCase.deleteBookMark(
        id: state.bookMark!.id,
      );

      emit(
        state.copyWithBookMarkNull(),
      );
    } else {
      await _bookMarkUseCase.addBookMark(
        logo: event.logo,
        name: event.name,
        url: event.url,
        description: event.description,
      );

      final bookMark = await _bookMarkUseCase.getBookMarkByUrl(
        url: event.url,
      );

      emit(
        state.copyWith(
          bookMark: bookMark,
        ),
      );
    }
  }

  void _onAddNewBrowser(
    BrowserOnAddNewBrowserEvent event,
    Emitter<BrowserState> emit,
  ) async {
    final activeBrowser = await _browserManagementUseCase.addNewBrowser(
      logo: event.logo,
      siteName: event.siteName,
      url: event.url,
      screenShotUri: event.browserImage,
    );

    final browsers = await _browserManagementUseCase.getBrowsers();

    emit(
      state.copyWith(
        tabCount: browsers.length,
        currentBrowser: activeBrowser,
      ),
    );
  }

  void _onRefreshAccount(
    BrowserOnRefreshAccountEvent event,
    Emitter<BrowserState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedAccount: event.selectedAccount,
      ),
    );

    await Future.delayed(const Duration(
      seconds: 2,
    ));

    final accounts = await _auraAccountUseCase.getAccounts();

    emit(
      state.copyWith(
        accounts: accounts,
        selectedAccount: accounts.firstWhereOrNull(
          (e) => e.index == 0,
        ),
      ),
    );
  }

  Future<Browser> _getCurrentBrowser({
    required String url,
  }) async {
    Browser? activeBrowser = await _browserManagementUseCase.getActiveBrowser();

    activeBrowser ??= await _browserManagementUseCase.addNewBrowser(
      url: url,
      logo: '',
      siteName: getSiteNameFromUrl(url),
      screenShotUri: '',
    );

    return activeBrowser;
  }

  String getSiteNameFromUrl(String url){
    final uri = Uri.parse(url);

    return uri.query.isNotEmpty ? uri.query : uri.host;
  }
}

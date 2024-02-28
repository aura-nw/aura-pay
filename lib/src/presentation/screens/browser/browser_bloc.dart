import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
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
    on(_onUpdateImage);
  }

  void _onUpdateImage(
    BrowserOnUpdateBrowserImage event,
    Emitter<BrowserState> emit,
  ) async {

    final currentBrowser = state.currentBrowser;

    if(currentBrowser != null){
      await _browserManagementUseCase.update(
        id: currentBrowser.id,
        url: currentBrowser.url,
        logo: currentBrowser.logo,
        siteName: currentBrowser.siteTitle,
        screenShotUri: event.path ?? currentBrowser.screenShotUri,
        isActive: currentBrowser.isActive,
      );
    }
  }

  void _onUrlChangeEvent(
    BrowserOnUrlChangeEvent event,
    Emitter<BrowserState> emit,
  ) async {
    final bookMark = await _bookMarkUseCase.getBookMarkByUrl(url: event.url);

    final currentBrowser = state.currentBrowser;

    if(currentBrowser != null){
      await _browserManagementUseCase.update(
        id: currentBrowser.id,
        url: event.url,
        logo: event.logo ?? currentBrowser.logo,
        siteName: currentBrowser.siteTitle,
        screenShotUri: currentBrowser.screenShotUri,
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

    Browser? activeBrowser = await _browserManagementUseCase.getActiveBrowser();

    final uri = Uri.parse(state.currentUrl);

    String name = uri.query.isNotEmpty ? uri.query : uri.host;

    activeBrowser ??= await _browserManagementUseCase.addNewBrowser(
      url: state.currentUrl,
      logo: '',
      siteName: name,
      screenShotUri: '',
    );

    switch (state.option.browserOpenType) {
      case BrowserOpenType.normal:
        // update current tab
        await _browserManagementUseCase.update(
          id: activeBrowser.id,
          url: state.currentUrl,
          logo: activeBrowser.logo,
          siteName: name,
          screenShotUri: activeBrowser.screenShotUri,
          isActive: activeBrowser.isActive,
        );
        break;
      case BrowserOpenType.chooseOther:
        if (activeBrowser.id != state.option.choosingId) {
          // active browser
          await _browserManagementUseCase.update(
            id: state.option.choosingId!,
            url: state.currentUrl,
            logo: '',
            siteName: name,
            screenShotUri: '',
            isActive: true,
          );
        }
        break;
    }

    // Get all accounts
    final accounts = await _auraAccountUseCase.getAccounts();

    // Get all browsers
    final browsers = await _browserManagementUseCase.getBrowsers();

    emit(
      state.copyWith(
        accounts: accounts,
        tabCount: browsers.isEmpty ? 1 : browsers.length,
        status: BrowserStatus.loaded,
        currentBrowser: browsers.firstWhereOrNull((e) => e.isActive),
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
}

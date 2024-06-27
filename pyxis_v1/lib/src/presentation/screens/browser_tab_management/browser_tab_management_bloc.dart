import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'browser_tab_management_event.dart';
import 'browser_tab_management_state.dart';

class BrowserTabManagementBloc
    extends Bloc<BrowserTabManagementEvent, BrowserTabManagementState> {
  final BrowserManagementUseCase _browserManagementUseCase;

  BrowserTabManagementBloc(this._browserManagementUseCase)
      : super(
          const BrowserTabManagementState(),
        ) {
    on(_onInit);
    on(_onClose);
    on(_onClear);
    on(_onAddNewTab);

    add(
      const BrowserTabManagementOnInitEvent(),
    );
  }

  // Default site information
  final String googleSearchUrl = 'https://www.google.com/search';
  final String _googleSearchName = 'Google search';

  void _onInit(
    BrowserTabManagementOnInitEvent event,
    Emitter<BrowserTabManagementState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BrowserTabManagementStatus.loading,
      ),
    );

    final browsers = await _browserManagementUseCase.getBrowsers();

    emit(
      state.copyWith(
        status: BrowserTabManagementStatus.loaded,
        browsers: browsers,
      ),
    );
  }

  void _onClose(
    BrowserTabManagementOnCloseTabEvent event,
    Emitter<BrowserTabManagementState> emit,
  ) async {
    // If browsers have only element. It looks like the BrowserTabManagementOnClearEvent
    if (state.browsers.length == 1) {
      add(
        const BrowserTabManagementOnClearEvent(),
      );
    } else {
      List<Browser> browsers = List.empty(growable: true)
        ..addAll(state.browsers);

      // Remove element by id
      browsers.removeWhere(
        (browser) => browser.id == event.id,
      );

      // Remove element in browser database
      await _browserManagementUseCase.deleteBrowser(
        id: event.id,
      );
      // Update UI
      emit(
        state.copyWith(
          browsers: browsers,
        ),
      );
      // Get active browser
      final activeBrowser = browsers.firstWhereOrNull((e) => e.isActive);

      // If activeBrowser null. We have to update a new active browser which is the first element
      if (activeBrowser == null) {
        Browser browser = state.browsers[0];

        // Update browser by id. It returns a browser after update
        browser = await _browserManagementUseCase.update(
          id: browser.id,
          url: browser.url,
          logo: browser.logo,
          siteName: browser.siteTitle,
          screenShotUri: browser.screenShotUri,
          isActive: true,
        );

        // Update UI
        emit(
          state.copyWith(
            browsers: browsers,
            activeBrowser: browser,
            status: BrowserTabManagementStatus.closeTabSuccess,
          ),
        );
      }
    }
  }

  void _onAddNewTab(
    BrowserTabManagementOnAddNewTabEvent event,
    Emitter<BrowserTabManagementState> emit,
  ) async {
    // Create a new browser
    final browser = await _createNewSite();

    // Update UI
    emit(
      state.copyWith(
        status: BrowserTabManagementStatus.addTabSuccess,
        activeBrowser: browser,
        browsers: [
          browser,
          ...state.browsers,
        ],
      ),
    );
  }

  void _onClear(
    BrowserTabManagementOnClearEvent event,
    Emitter<BrowserTabManagementState> emit,
  ) async {
    // Clear all browser in browser database
    await _browserManagementUseCase.deleteAll();

    // Create a new browser
    final browser = await _createNewSite();

    // Update UI
    emit(
      state.copyWith(
        status: BrowserTabManagementStatus.closeAllSuccess,
        activeBrowser: browser,
        browsers: [
          browser,
        ],
      ),
    );
  }

  Future<Browser> _createNewSite() async {
    return _browserManagementUseCase.addNewBrowser(
      url: googleSearchUrl,
      logo: '',
      siteName: _googleSearchName,
      screenShotUri: '',
    );
  }
}

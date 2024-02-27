import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    if (state.browsers.length == 1) {
      add(
        const BrowserTabManagementOnClearEvent(),
      );
    } else {
      final List<Browser> browsers = List.empty(growable: true)
        ..addAll(state.browsers);

      browsers.removeAt(0);

      final browser = state.browsers[0];

      await _browserManagementUseCase.deleteBrowser(
        id: event.id,
      );

      await _browserManagementUseCase.update(
        id: browser.id,
        url: browser.url,
        logo: browser.logo,
        siteName: browser.siteTitle,
        screenShotUri: browser.screenShotUri,
        isActive: true,
      );

      emit(
        state.copyWith(
          browsers: browsers,
          status: BrowserTabManagementStatus.closeTabSuccess,
        ),
      );
    }
  }

  void _onAddNewTab(
    BrowserTabManagementOnAddNewTabEvent event,
    Emitter<BrowserTabManagementState> emit,
  ) async {
    await _createNewSite();

    emit(
      state.copyWith(
        status: BrowserTabManagementStatus.addTabSuccess,
      ),
    );
  }

  void _onClear(
    BrowserTabManagementOnClearEvent event,
    Emitter<BrowserTabManagementState> emit,
  ) async {
    await _browserManagementUseCase.deleteAll();

    await _createNewSite();

    emit(
      state.copyWith(
        status: BrowserTabManagementStatus.closeAllSuccess,
      ),
    );
  }

  Future<void> _createNewSite() async {
    await _browserManagementUseCase.addNewBrowser(
      url: googleSearchUrl,
      logo: '',
      siteName: _googleSearchName,
      screenShotUri: '',
    );
  }
}

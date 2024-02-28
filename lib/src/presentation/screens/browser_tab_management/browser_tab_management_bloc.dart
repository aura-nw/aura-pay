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
      List<Browser> browsers = List.empty(growable: true)
        ..addAll(state.browsers);

      browsers.removeWhere(
        (browser) => browser.id == event.id,
      );

      emit(
        state.copyWith(
          browsers: browsers,
        ),
      );

      final activeBrowser = browsers.firstWhereOrNull((e) => e.isActive);

      if (activeBrowser == null) {
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

        browsers = await _browserManagementUseCase.getBrowsers();

        emit(
          state.copyWith(
            browsers: browsers,
            activeBrowser: browsers.firstWhereOrNull(
              (br) => br.isActive,
            ),
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
    final browser = await _createNewSite();

    emit(
      state.copyWith(
          status: BrowserTabManagementStatus.addTabSuccess,
          activeBrowser: browser,
          browsers: [
            browser,
            ...state.browsers,
          ]),
    );
  }

  void _onClear(
    BrowserTabManagementOnClearEvent event,
    Emitter<BrowserTabManagementState> emit,
  ) async {
    await _browserManagementUseCase.deleteAll();

    final browser = await _createNewSite();

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

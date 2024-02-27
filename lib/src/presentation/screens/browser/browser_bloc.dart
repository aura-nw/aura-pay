import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'browser_event.dart';
import 'browser_state.dart';

class BrowserBloc extends Bloc<BrowserEvent, BrowserState> {
  final AuraAccountUseCase _auraAccountUseCase;
  final BrowserManagementUseCase _browserManagementUseCase;
  final BookMarkUseCase _bookMarkUseCase;

  BrowserBloc(
    this._auraAccountUseCase,
    this._browserManagementUseCase,
    this._bookMarkUseCase,
  ) : super(
          const BrowserState(),
        ) {
    on(_onInit);
    on(_onUrlChangeEvent);
    on(_onBookMarkClick);
    on(_onAddNewBrowser);
    on(_onRefreshAccount);
  }

  void _onUrlChangeEvent(
    BrowserOnUrlChangeEvent event,
    Emitter<BrowserState> emit,
  ) async {
    final bookMark = await _bookMarkUseCase.getBookMarkByUrl(url: event.url);

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

    final accounts = await _auraAccountUseCase.getAccounts();

    final browsers = await _browserManagementUseCase.getBrowsers();

    emit(
      state.copyWith(
        currentUrl: event.url,
        accounts: accounts,
        tabCount: browsers.length,
        status: BrowserStatus.loaded,
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
    await _browserManagementUseCase.addNewBrowser(
      logo: event.logo,
      siteName: event.siteName,
      url: event.url,
      isActive: true,
    );

    final browsers = await _browserManagementUseCase.getBrowsers();

    emit(
      state.copyWith(
        tabCount: browsers.length,
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

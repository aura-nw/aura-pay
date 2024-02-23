import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'browser_page_event.dart';
import 'browser_page_state.dart';

class BrowserPageBloc extends Bloc<BrowserPageEvent, BrowserPageState> {
  final BrowserManagementUseCase _browserManagementUseCase;
  final BookMarkUseCase _bookMarkUseCase;

  BrowserPageBloc(
    this._browserManagementUseCase,
    this._bookMarkUseCase,
  ) : super(
          const BrowserPageState(),
        ) {
    on(_onInit);
    on(_onTabChange);
    on(_onDeleteBookMark);

    add(
      const BrowserPageOnInitEvent(),
    );
  }

  void _onInit(
    BrowserPageOnInitEvent event,
    Emitter<BrowserPageState> emit,
  ) async {
    final browsers = await _browserManagementUseCase.getBrowsers();
    final bookMarks = await _bookMarkUseCase.getBookmarks();

    emit(
      state.copyWith(
        bookMarks: bookMarks,
        tabCount: browsers.length,
      ),
    );
  }

  void _onTabChange(
    BrowserPageOnChangeTabEvent event,
    Emitter<BrowserPageState> emit,
  ) {
    if (event.index != state.currentTab) {
      emit(
        state.copyWith(
          currentTab: event.index,
        ),
      );
    }
  }

  void _onDeleteBookMark(
    BrowserPageOnDeleteBookMarkEvent event,
    Emitter<BrowserPageState> emit,
  ) async {
    final List<BookMark> disPlayBookMarks = List.empty(growable: true);

    state.bookMarks.removeWhere((e) => e.id == event.id);

    disPlayBookMarks.addAll(state.bookMarks);

    emit(
      state.copyWith(
        bookMarks: disPlayBookMarks,
      ),
    );

    await _bookMarkUseCase.deleteBookMark(
      id: event.id,
    );
  }
}

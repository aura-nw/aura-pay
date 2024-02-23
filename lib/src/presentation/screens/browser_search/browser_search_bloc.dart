import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/aura_ecosystem.dart';
import 'browser_search_event.dart';
import 'browser_search_state.dart';

class BrowserSearchBloc extends Bloc<BrowserSearchEvent, BrowserSearchState> {
  BrowserSearchBloc()
      : super(
          const BrowserSearchState(),
        ){
    on(_onQuery);
  }

  void _onQuery(
    BrowserSearchOnQueryEvent event,
    Emitter<BrowserSearchState> emit,
  ) {
    final List<BrowserInformation> displays = List.empty(
      growable: true,
    );

    if (event.query.isEmpty) {
      displays.addAll(auraEcosystems);
    } else {
      final mapByQuery = auraEcosystems
          .where(
            (system) => system.name.toLowerCase().contains(
              event.query.toLowerCase(),
            ),
          )
          .toList();

      displays.addAll(mapByQuery);
    }

    emit(
      state.copyWith(
        query: event.query,
        systems: displays,
      ),
    );
  }
}

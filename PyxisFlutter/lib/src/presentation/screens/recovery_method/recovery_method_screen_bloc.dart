import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'recovery_method_screen_event.dart';
import 'recovery_method_screen_state.dart';

class RecoveryMethodScreenBloc
    extends Bloc<RecoveryMethodScreenEvent, RecoveryMethodScreenState> {
  final AuraAccountUseCase _accountUseCase;

  RecoveryMethodScreenBloc(this._accountUseCase)
      : super(
          const RecoveryMethodScreenState(),
        ) {
    on(_fetchAccounts);
    on(_refreshAccount);
  }

  void _fetchAccounts(
    RecoveryMethodScreenEventFetchAccount event,
    Emitter<RecoveryMethodScreenState> emit,
  ) async {
    emit(
      state.copyWith(
        status: RecoveryMethodScreenStatus.loading,
      ),
    );

    try {
      final List<AuraAccount> accounts = await _accountUseCase.getAccounts();

      final List<AuraAccount> smartAccounts = accounts
          .where(
            (ac) => ac.type == AuraAccountType.smartAccount,
          )
          .toList();

      emit(
        state.copyWith(
          status: RecoveryMethodScreenStatus.loaded,
          accounts: smartAccounts,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RecoveryMethodScreenStatus.error,
        ),
      );
    }
  }

  void _refreshAccount(
      RecoveryMethodScreenEventRefresh event,
    Emitter<RecoveryMethodScreenState> emit,
  ) async {
    try {
      final List<AuraAccount> accounts = await _accountUseCase.getAccounts();

      final List<AuraAccount> smartAccounts = accounts
          .where(
            (ac) => ac.type == AuraAccountType.smartAccount,
          )
          .toList();

      emit(
        state.copyWith(
          status: RecoveryMethodScreenStatus.loaded,
          accounts: smartAccounts,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RecoveryMethodScreenStatus.error,
        ),
      );
    }
  }
}

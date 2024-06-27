import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'controller_key_management_state.dart';

class ControllerKeyManagementCubit extends Cubit<ControllerKeyManagementState> {
  final AuraAccountUseCase _auraAccountUseCase;

  ControllerKeyManagementCubit(this._auraAccountUseCase)
      : super(
          const ControllerKeyManagementState(),
        );

  void fetchAccounts() async {
    emit(
      state.copyWith(
        status: ControllerKeyManagementStatus.loading,
      ),
    );

    try {
      final accounts = await _auraAccountUseCase.getAccounts();

      emit(
        state.copyWith(
          status: ControllerKeyManagementStatus.loaded,
          accounts: accounts
              .where(
                (e) => e.type == AuraAccountType.normal,
              )
              .toList(),
        ),
      );
    } catch (e) {
      LogProvider.log('Fetch account error ${e.toString()}');
      emit(
        state.copyWith(
          status: ControllerKeyManagementStatus.error,
        ),
      );
    }
  }
}

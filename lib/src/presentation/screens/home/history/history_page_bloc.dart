import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';
import 'history_page_event.dart';

import 'history_page_state.dart';

final class HistoryPageBloc extends Bloc<HistoryPageEvent, HistoryPageState> {
  final TransactionUseCase _transactionUseCase;
  final AuraAccountUseCase _accountUseCase;

  HistoryPageBloc(
    this._transactionUseCase,
    this._accountUseCase,
  ) : super(
          const HistoryPageState(),
        ) {
    on(_onInit);
    on(_onLoadMore);
    on(_onRefresh);
    on(_onFilter);
    on(_onChangeAccount);
  }

  Future<List<PyxisTransaction>> _getTransaction({
    int? heightLt,
    String? receive,
  }) async {
    final List<PyxisTransaction> transactions =
        await _transactionUseCase.getTransactions(
      limit: state.limit,
      environment: state.environment,
      sender: state.selectedAccount?.address,
      msgTypes: state.currentTab.messages,
      heightLt: heightLt,
      receive: state.currentTab.getReceive(
        receive ?? state.selectedAccount?.address,
      ),
    );

    return transactions.where(
      (transaction) {
        final MsgType type = TransactionHelper.getMsgType(
          transaction.messages[0].content,
        );

        if (type == MsgType.other) {
          return false;
        }

        if (type == MsgType.executeContract) {
          return TransactionHelper.validateMsgSetRecovery(
              transaction.messages[0].content);
        }

        return true;
      },
    ).toList();
  }

  void _onInit(
    HistoryPageEventOnInit event,
    Emitter<HistoryPageState> emit,
  ) async {
    final config = getIt.get<PyxisMobileConfig>();

    emit(
      state.copyWith(
        status: HistoryPageStatus.loading,
        environment: config.environment.environmentString,
      ),
    );

    try {
      final accounts = await _accountUseCase.getAccounts();

      emit(
        state.copyWith(
          selectedAccount: accounts.firstOrNull,
          accounts: accounts,
        ),
      );

      final transactions = await _getTransaction(
        receive: accounts.firstOrNull?.address,
      );

      emit(
        state.copyWith(
          status: HistoryPageStatus.loaded,
          canLoadMore: transactions.length == 30,
          transactions: transactions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HistoryPageStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _onLoadMore(
    HistoryPageEventOnLoadMore event,
    Emitter<HistoryPageState> emit,
  ) async {
    if (state.status != HistoryPageStatus.loaded) return;

    emit(
      state.copyWith(
        status: HistoryPageStatus.loadMore,
      ),
    );

    try {
      final transactions = await _getTransaction(
        heightLt: state.transactions.lastOrNull?.heightLt,
      );

      emit(
        state.copyWith(
          status: HistoryPageStatus.loaded,
          canLoadMore: transactions.length == 30,
          transactions: [
            ...state.transactions,
            ...transactions,
          ],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HistoryPageStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _onRefresh(
    HistoryPageEventOnRefresh event,
    Emitter<HistoryPageState> emit,
  ) async {
    if (state.status != HistoryPageStatus.loaded) return;

    emit(
      state.copyWith(
        status: HistoryPageStatus.loading,
        transactions: [],
      ),
    );

    try {
      final transactions = await _getTransaction();

      emit(
        state.copyWith(
          status: HistoryPageStatus.loaded,
          canLoadMore: transactions.length == 30,
          transactions: transactions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HistoryPageStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void _onFilter(
    HistoryPageEventOnFilter event,
    Emitter<HistoryPageState> emit,
  ) async {
    emit(
      state.copyWith(
        currentTab: TransactionHistoryEnum.values[event.index],
      ),
    );

    add(
      const HistoryPageEventOnRefresh(),
    );
  }

  void _onChangeAccount(
    HistoryPageEventOnChangeSelectedAccount event,
    Emitter<HistoryPageState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedAccount: event.selectedAccount,
      ),
    );

    add(
      const HistoryPageEventOnRefresh(),
    );
  }
}

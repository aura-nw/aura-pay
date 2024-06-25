import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_state.dart';
import 'package:pyxis_mobile/src/core/pyxis_wallet_core/pyxis_wallet_helper.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/core/wallet_core/pyxis_wallet_connect_service.dart';
import 'confirm_transaction_screen_event.dart';

import 'confirm_transaction_screen_state.dart';

final class WalletConnectConfirmTransactionBloc extends Bloc<
    WalletConnectConfirmTransactionEvent,
    WalletConnectConfirmTransactionState> {
  final ControllerKeyUseCase _controllerKeyUseCase;
  final AuraAccountUseCase _accountUseCase;
  final PyxisWalletConnectService _walletConnectService;
  final SmartAccountUseCase _smartAccountUseCase;

  WalletConnectConfirmTransactionBloc(
      this._controllerKeyUseCase,
      this._accountUseCase,
      this._walletConnectService,
      this._smartAccountUseCase)
      : super(
          WalletConnectConfirmTransactionState(),
        ) {
    on(_onInit);
    on(_onChangeFee);
    on(_onConfirm);
    on(_onChangeMemo);

    add(
      const WalletConnectConfirmTransactionEventOnInit(),
    );
  }

  final config = getIt.get<PyxisMobileConfig>();

  final int _defaultGasLimit = 400000;

  void _onInit(
    WalletConnectConfirmTransactionEventOnInit event,
    Emitter<WalletConnectConfirmTransactionState> emit,
  ) async {
    // Set default gas
    final highFee = CosmosHelper.calculateFee(
      _defaultGasLimit,
      deNom: config.deNom,
      gasPrice: GasPriceStep.high.value,
    );

    final fee = CosmosHelper.calculateFee(
      _defaultGasLimit,
      deNom: config.deNom,
      gasPrice: GasPriceStep.average.value,
    );

    final lowFee = CosmosHelper.calculateFee(
      _defaultGasLimit,
      deNom: config.deNom,
      gasPrice: GasPriceStep.low.value,
    );

    emit(
      state.copyWith(
        highTransactionFee: highFee.amount[0].amount,
        lowTransactionFee: lowFee.amount[0].amount,
        transactionFee: fee.amount[0].amount,
      ),
    );
  }

  void _onChangeMemo(
    WalletConnectConfirmTransactionEventOnChangeMemo event,
    Emitter<WalletConnectConfirmTransactionState> emit,
  ) {
    emit(
      state.copyWith(
        memo: event.memo,
        status: WalletConnectConfirmTransactionStatus.none,
      ),
    );
  }

  void _onChangeFee(
    WalletConnectConfirmTransactionEventOnChangeFee event,
    Emitter<WalletConnectConfirmTransactionState> emit,
  ) async {
    emit(
      state.copyWith(
        transactionFee: event.fee,
        status: WalletConnectConfirmTransactionStatus.none,
      ),
    );
  }

  void _onConfirm(
    WalletConnectConfirmTransactionEventOnConfirm event,
    Emitter<WalletConnectConfirmTransactionState> emit,
  ) async {
    RequestSessionData requestSessionData = event.requestSessionData;
    emit(
      state.copyWith(
        status: WalletConnectConfirmTransactionStatus.onApprove,
      ),
    );

    if (requestSessionData.method == 'cosmos_signAmino') {
      print(requestSessionData.params);
      final String signer = requestSessionData.params['signerAddress'];

      final String privateKey =
          await _controllerKeyUseCase.getKey(address: signer) ?? '';
      final String pubKey =
          await _smartAccountUseCase.getCosmosPubKeyByAddress(address: signer);

      try {
        Map<String, dynamic> msg = PyxisWalletHelper.signAmino(
          signDoc: requestSessionData.params['signDoc'],
          privateKeyHex: privateKey,
          pubKeyHex: pubKey,
        );
        _walletConnectService.approveRequest(
            id: requestSessionData.id,
            topic: requestSessionData.topic,
            msg: msg);
      } catch (e, s) {
        print(e);
      }
      return;
    }
  }

  void approveTransaction() {}
}

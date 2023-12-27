import 'dart:typed_data';
import 'package:data/data.dart';
import 'package:domain/domain.dart';

class SmartAccountRepositoryImpl implements SmartAccountRepository {
  final SmartAccountProvider _provider;
  final SmartAccountApiService _apiService;
  final RecoveryAccountDatabaseService _databaseService;

  const SmartAccountRepositoryImpl(
    this._provider,
    this._apiService,
    this._databaseService,
  );

  @override
  Future<TransactionInformation> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    String? fee,
    int? gasLimit,
  }) async {
    return await _provider.activeSmartAccount(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      fee: fee,
      gasLimit: gasLimit,
      salt: salt,
      memo: memo,
    );
  }

  @override
  Future<String> generateAddress({
    required Uint8List pubKey,
    Uint8List? salt,
  }) async {
    return await _provider.generateSmartAccount(
      pubKey: pubKey,
      salt: salt,
    );
  }

  @override
  Future<TransactionInformation> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
    String? fee,
    int? gasLimit,
  }) async {
    final transactionResponse = await _provider.sendToken(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      receiverAddress: receiverAddress,
      amount: amount,
      fee: fee,
      gasLimit: gasLimit,
      memo: memo,
    );
    return transactionResponse.toEntity;
  }

  @override
  Future<String> getToken({
    required String address,
  }) async {
    return _provider.getToken(
      address: address,
    );
  }

  @override
  Future<int> simulateFee(
      {required Uint8List userPrivateKey,
      required String smartAccountAddress,
      dynamic msg}) {
    return _provider.simulateFee(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      msg: msg,
    );
  }

  @override
  Future<TransactionInformation> getTx({required String txHash}) async {
    final response = await _provider.getTx(
      txHash: txHash,
    );
    return response.toEntity;
  }

  @override
  Future<TransactionInformation> setRecoveryMethod({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String recoverAddress,
    String? fee,
    int? gasLimit,
    bool isReadyRegister = false,
    String? revokePreAddress,
  }) async {
    final response = await _provider.setRecoveryMethod(
      userPrivateKey: userPrivateKey,
      smartAccountAddress: smartAccountAddress,
      recoverAddress: recoverAddress,
      fee: fee,
      gasLimit: gasLimit,
      isReadyRegister: isReadyRegister,
      revokePreAddress: revokePreAddress,
    );

    return response.toEntity;
  }

  @override
  Future<TransactionInformation> recoverSmartAccount({
    required Uint8List privateKey,
    required String recoverAddress,
    required String smartAccountAddress,
    String? fee,
    int? gasLimit,
  }) async {
    final response = await _provider.recoverSmartAccount(
      privateKey: privateKey,
      smartAccountAddress: smartAccountAddress,
      recoverAddress: recoverAddress,
      fee: fee,
      gasLimit: gasLimit,
    );

    return response.toEntity;
  }

  @override
  Future<List<PyxisRecoveryAccount>> getRecoveryAccountByAddress({
    required Map<String, dynamic> queries,
  }) async {
    final response = await _apiService.getRecoveryAccountByAddress(
      queries: queries,
    );

    const String accounts = 'pyxis_recovery_account';

    final data = response.data ??
        {
          accounts: [],
        };

    final List<PyxisRecoveryAccountDto> accountsDto =
        List.empty(growable: true);

    for (final json in data[accounts]) {
      final PyxisRecoveryAccountDto accountDto =
          PyxisRecoveryAccountDto.fromJson(json);

      accountsDto.add(accountDto);
    }

    return accountsDto.map((e) => e.toEntity).toList();
  }

  @override
  Future<void> insertRecoveryAccount({
    required Map<String, dynamic> body,
  }) async {
    await _apiService.insertRecoveryAccount(
      body: body,
    );
  }

  @override
  Future<void> insertLocalRecoveryAccount({
    required String recoveryAddress,
    required String smartAccountAddress,
    required String name,
  }) async {
    return _databaseService.saveRecoveryAccount(
      recoveryAddress: recoveryAddress,
      smartAccountAddress: smartAccountAddress,
      name: name,
    );
  }

  @override
  Future<List<LocalRecoveryAccount>> getLocalRecoveryAccounts() async{
    final accounts = await _databaseService.getAuraAccounts();

    return accounts.map((e) => e.toEntity).toList();
  }

  @override
  Future<void> deleteLocalRecoveryAccount({required int id}) {
    return _databaseService.deleteAccount(id);
  }
}

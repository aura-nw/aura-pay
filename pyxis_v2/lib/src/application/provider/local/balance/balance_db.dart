import 'package:data/data.dart';
import 'package:isar/isar.dart';

part 'balance_db.g.dart';

extension AddAccountBalanceRequestDtoMapper on AddAccountBalanceRequestDto {
  AccountBalanceDb get mapRequestToDb => AccountBalanceDb(
        aAccountId: accountId,
        aCosmosBalance: cosmosBalance.mapRequestToDb,
        aEvmBalance: evmBalance.mapRequestToDb,
      );
}

extension AddBalanceRequestDtoMapper on AddBalanceRequestDto {
  BalanceDb get mapRequestToDb => BalanceDb(
        bBalance: balance,
        bTokenId: tokenId,
      );
}

extension AccountBalanceDbExtension on AccountBalanceDb {
  AccountBalanceDb copyWith({
    int? id,
    int? eTokenId,
    String? eBalance,
    int? cTokenId,
    String? cBalance,
  }) {
    return AccountBalanceDb(
      aId: id ?? aId,
      aAccountId: aAccountId,
      aCosmosBalance: aCosmosBalance.copyWith(
        tokenId: cTokenId,
        balance: cBalance,
      ),
      aEvmBalance: aEvmBalance.copyWith(
        tokenId: eTokenId,
        balance: eBalance,
      ),
    );
  }
}

extension BalanceDbExtension on BalanceDb {
  BalanceDb copyWith({
    int? tokenId,
    String? balance,
  }) {
    return BalanceDb(
      bTokenId: tokenId ?? bTokenId,
      bBalance: balance ?? bBalance,
    );
  }
}

@Collection(inheritance: false)
class AccountBalanceDb extends AccountBalanceDto {
  final Id aId;
  final int aAccountId;
  final BalanceDb aCosmosBalance;
  final BalanceDb aEvmBalance;

  const AccountBalanceDb({
    this.aId = Isar.autoIncrement,
    required this.aAccountId,
    required this.aCosmosBalance,
    required this.aEvmBalance,
  }) : super(
          id: aId,
          accountId: aAccountId,
          cosmosBalance: aCosmosBalance,
          evmBalance: aEvmBalance,
        );
}

@embedded
class BalanceDb extends BalanceDto {
  final String bBalance;
  final int bTokenId;

  const BalanceDb({
    this.bBalance = '0',
    this.bTokenId = -1,
  }) : super(
          balance: bBalance,
          tokenId: bTokenId,
        );
}

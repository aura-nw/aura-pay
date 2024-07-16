import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';

part 'balance_db.g.dart';

extension UpdateBalanceRequestDtoMapper on UpdateBalanceRequestDto {
  BalanceDb get mapRequestToDb => BalanceDb(
        bBalance: balance,
        bTokenId: tokenId,
        bType: type,
      );
}

extension AddAccountBalanceRequestDtoMapper on AddAccountBalanceRequestDto {
  AccountBalanceDb get mapRequestToDb => AccountBalanceDb(
      aAccountId: accountId,
      aBalances: balances
          .map(
            (e) => e.mapRequestToDb,
          )
          .toList());
}

extension AddBalanceRequestDtoMapper on AddBalanceRequestDto {
  BalanceDb get mapRequestToDb => BalanceDb(
        bBalance: balance,
        bTokenId: tokenId,
        bType: type,
      );
}

extension AccountBalanceDbExtension on AccountBalanceDb {
  AccountBalanceDb copyWith({
    int? id,
    List<BalanceDb>? balances,
  }) {
    return AccountBalanceDb(
      aId: id ?? aId,
      aAccountId: aAccountId,
      aBalances: balances ?? aBalances,
    );
  }
}

extension BalanceDbExtension on BalanceDb {
  BalanceDb copyWith({
    int? tokenId,
    String? balance,
    String? type,
  }) {
    return BalanceDb(
      bTokenId: tokenId ?? bTokenId,
      bBalance: balance ?? bBalance,
      bType: type ?? bType,
    );
  }
}

@Collection(inheritance: false)
class AccountBalanceDb extends AccountBalanceDto {
  final Id aId;
  final int aAccountId;
  final List<BalanceDb> aBalances;

  const AccountBalanceDb({
    this.aId = Isar.autoIncrement,
    required this.aAccountId,
    required this.aBalances,
  }) : super(
          id: aId,
          accountId: aAccountId,
          balances: aBalances,
        );
}

@embedded
class BalanceDb extends BalanceDto {
  final String bBalance;
  final int bTokenId;
  final String bType;

  const BalanceDb({
    this.bBalance = '0',
    this.bTokenId = -1,
    this.bType = 'evm',
  }) : super(
          balance: bBalance,
          tokenId: bTokenId,
          type: bType,
        );
}

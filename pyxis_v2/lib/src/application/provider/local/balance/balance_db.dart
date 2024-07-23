import 'package:data/data.dart';
import 'package:isar/isar.dart';

part 'balance_db.g.dart';

extension UpdateBalanceRequestDtoMapper on UpdateBalanceRequestDto {
  BalanceDb get mapRequestToDb => BalanceDb(
        bBalance: balance,
        bTokenId: tokenId,
        bTokenType: type,
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
        bTokenType: type,
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
      bTokenType: type ?? bTokenType,
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
  final int ?bTokenId;
  final String bTokenType;

  const BalanceDb({
    this.bBalance = '0',
    this.bTokenId,
    this.bTokenType = 'Native',
  }) : super(
          balance: bBalance,
          tokenId: bTokenId,
          tokenType: bTokenType,
        );
}

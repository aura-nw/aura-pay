import 'package:domain/src/domain/entities/grant_fee.dart';

abstract interface class FeeGrantRepository{
  Future<GrantFee> grantFee({
    required Map<String, dynamic> body,
  });
}
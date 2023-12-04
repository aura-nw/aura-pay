import 'package:data/src/data/dto/dto.dart';
import 'package:isar/isar.dart';

final class AccountStorageService{
  final Isar _isar;

  const AccountStorageService(this._isar);

  Future<AuraAccountDto?> getAccount(int id)async{
    return await _isar.auraAccountDtos.get(id);
  }
  
  Future<void> saveAccount(AuraAccountDto accountDto)async{
    await _isar.writeTxn(()async{
      await _isar.auraAccountDtos.put(accountDto);
    });
  }
  
  Future<List<AuraAccountDto>> getAuraAccounts()async{
    return await _isar.auraAccountDtos.where().findAll();
  }
  
  Future<void> deleteAccount(int id)async{
    await _isar.writeTxn(()async{
      await _isar.auraAccountDtos.delete(id);
    });
  }
  
  Future<void> updateAccount(AuraAccountDto accountDto)async{
    await _isar.writeTxn(() async {
      await _isar.auraAccountDtos.delete(accountDto.id);
      await _isar.auraAccountDtos.put(accountDto);
    });
  }
}
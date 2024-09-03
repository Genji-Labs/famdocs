import 'package:famdocs/database/database_helper.dart';
import 'package:famdocs/models/family.dart';
import 'package:famdocs/services/encryption/sha_hasher.dart';

class PasswordDatabaseHelper extends DatabaseHelper{
  PasswordDatabaseHelper(int version){
    super.initDB(version);
  }

  Future<void> addPassword(BigInt familyId,String password) async{
    await syncer();
    await db!.execute('insert into passwords(family_id,password) values(?,?)',
        [familyId.toString(),password]);
  }

  Future<String?> getPassword(BigInt familyId) async{
    await syncer();
    List<Map<String,dynamic>> queryResult = await db!.rawQuery('select password from passwords where family_id=?',
    [familyId.toString()]);
    if(queryResult.isEmpty) return null;
    return queryResult[0]["password"];
  }

  Future<bool> checkPasswordEntry(BigInt familyId) async{
    await syncer();
    List<Map<String,dynamic>> queryResult = await db!.rawQuery('select password from passwords where family_id=?',
        [familyId.toString()]);
    if(queryResult.isEmpty) return false;
    return true;
  }
}
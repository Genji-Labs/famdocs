
import 'package:famdocs/database/database_helper.dart';
import 'package:famdocs/models/family.dart';

class FamilyDatabaseHelper extends DatabaseHelper{
  FamilyDatabaseHelper(int version){
    super.initDB(version);
  }

  Future<void> insertFamily(Family family) async{
    await syncer();
    await db!.transaction((txn) async{
      txn.rawInsert('insert into families(id,name,owner,sha_hash) values(?,?,?,?)',
          [family.familyId.toString(),family.familyName.toString(),family.ownerId.toString(),
            family.shaHash.toString()]);
    });
  }

  Future<Family?> getFamily(BigInt id) async{
    await syncer();
    List<Map<String,dynamic>> queryResult = await db!.rawQuery('select * from families where id=?',[id.toString()]);
    if(queryResult.isEmpty) return null;
    return Family.fromMap(queryResult[0]);
  }


  Future<List<Family>?> getAllFamilies() async{
    await syncer();
    List<Map<String,dynamic>> queryResult = await db!.rawQuery('select '
        'families.id as id,families.name as name,families.owner '
        'as owner, families.sha_hash as sha_hash,'
        'folders.name as folder_name,'
        'folders.id as folder_id from families '
        'inner join folders on families.id=folders.family_id');
    if(queryResult.isEmpty) return null;
    return queryResult.map((e){
      Map<String,dynamic> copy = Map.from(e);
      copy["root"] = {"id":e["folder_id"],"name":e["folder_name"],"family_id":e["id"]};
      return Family.fromMap(copy);
    }).toList();
  }

  void deleteFamily(){}
}
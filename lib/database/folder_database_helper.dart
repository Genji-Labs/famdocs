import 'package:famdocs/database/database_helper.dart';
import 'package:famdocs/models/folder.dart';

class FolderDatabaseHelper extends DatabaseHelper{
  FolderDatabaseHelper(int version){
    super.initDB(version);
  }

  Future<void> insertFolder(Folder folder) async{
    await syncer();
    await db!.transaction((txn) async{
      txn.rawInsert('insert into folders(id,name,family_id) values(?,?,?)',
          [folder.id.toString(),folder.name.toString(),folder.familyId.toString()]);
    });
  }

  void deleteFolder(){}

  void getFolder(){}

}
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  Database? db;
  void initDB(int version) async{
    db = await openDatabase("fam.db",onCreate: (db,version){
      db.execute('create table families(id bigint unique,name varchar(20),owner bigint,sha_hash varchar(64))');
      db.execute('create table folders(id bigint unique,name varchar(20),'
          'family_id bigint,foreign key(family_id) references families(id))');
      db.execute('create table passwords(family_id bigint,password varchar(50))');
    },version: version);
  }

  Future<void> syncer() async{
    while(db==null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void closeDB(){
    db!.close();
  }
}
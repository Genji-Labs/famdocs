import 'dart:convert';

import 'folder.dart';

class Family{
  BigInt? familyId;
  String? familyName;
  BigInt? ownerId;
  String? shaHash;
  Folder? rootFolder;
  Family(this.familyId,this.familyName,this.ownerId,this.shaHash,this.rootFolder);

  Family.fromJson(String json){
    Map<String,dynamic> decoded = jsonDecode(json);
    familyId = BigInt.tryParse(decoded["id"].toString());
    familyName = decoded["name"].toString();
    ownerId = BigInt.tryParse(decoded["owner"].toString());
    shaHash = decoded["sha_hash"].toString();
    rootFolder = Folder.fromJson(jsonEncode(decoded["root"]));
  }

  Family.fromMap(Map<String,dynamic> decoded){
    familyId = BigInt.tryParse(decoded["id"].toString());
    familyName = decoded["name"].toString();
    ownerId = BigInt.tryParse(decoded["owner"].toString());
    shaHash = decoded["sha_hash"].toString();
    rootFolder = Folder.fromJson(jsonEncode(decoded["root"]));
  }
}
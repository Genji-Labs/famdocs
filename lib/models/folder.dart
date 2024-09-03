import 'dart:convert';

import 'package:famdocs/models/file.dart';

class Folder extends FamFile{
  BigInt? id;
  String? name;
  BigInt? familyId;
  BigInt? parentFolderId;
  Folder? parentFolder;

  Folder.fromJson(String json){
    Map<String,dynamic> decoded = jsonDecode(json);
    id = BigInt.tryParse(decoded["id"].toString());
    name = decoded["name"].toString();
    familyId = BigInt.tryParse(decoded["family_id"].toString());
    parentFolderId = BigInt.tryParse(decoded["parent_folder_id"].toString());
  }

}
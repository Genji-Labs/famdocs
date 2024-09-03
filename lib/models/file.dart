import 'dart:convert';
import 'dart:io' as system;
import 'folder.dart';

class File extends FamFile{
  String? name;
  BigInt? id;
  String? path;
  BigInt? folderId;
  Folder? parentFolder;
  system.File? systemFile;

  File();


  File.fromJson(String json){
    Map<String,dynamic> decoded = jsonDecode(json);
    id = BigInt.tryParse(decoded["id"].toString());
    name = decoded["name"].toString();
    folderId = BigInt.tryParse(decoded["folder_id"].toString());
    path = decoded["path"].toString();
  }

  String getIcon(){
    if(name==null) return "";
    String ext = "";
    for(int pointer=name!.length-1;pointer>=0;pointer--){
      if(name![pointer]=='.') break;
      ext = name![pointer]+ext;
    }
    switch(ext){
      case "docx":
        return "assets/files/docx.svg";
      case "java":
        return "assets/files/java.svg";
      case "jpg":
      case "jpeg":
        return "assets/files/jpg.svg";
      case "mp3":
        return "assets/files/mp3.svg";
      case "mp4":
        return "assets/files/mp4.svg";
      case "pdf":
        return "assets/files/pdf.svg";
      case "png":
        return "assets/files/png.svg";
      case "ppt":
        return "assets/files/ppt.svg";
      case "txt":
        return "assets/files/txt.svg";
      case "word":
        return "assets/files/word.svg";
      case "xls":
        return "assets/files/xls.svg";
      case "zip":
        return "assets/files/zip.svg";
      default:
        return "assets/files/no_format.svg";
    }
  }
}


abstract class FamFile{}


import 'dart:io';

import 'package:famdocs/exceptions/arbitrary_exception.dart';
import 'package:famdocs/exceptions/prefs_exception.dart';
import 'package:famdocs/models/folder.dart';
import 'package:famdocs/models/user.dart';
import 'package:famdocs/services/encryption/encrypter_decrypter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:famdocs/models/file.dart' as fileModel;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/resources.dart';

class FileRepository{
  Future<void> uploadFile(Folder parentFolder,String path,String fileName,
      String? extension) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString("user");
    String? url = prefs.getString("url");
    if(userString==null) throw PrefsException("User not set", "");
    if(url==null) throw PrefsException("Url not set", "");
    User user = User.fromJson(userString);
    if(user.token==null) throw ArbitraryException("Token is null", "");
    MultipartRequest request = MultipartRequest("POST", Uri.parse("$url/family/folder/file/create"));
    request.files.add(await MultipartFile.fromPath("file", path));
    request.headers["token"] = "token";
    request.fields["folder_id"] = parentFolder.id.toString();
    request.fields["file_name"] = fileName;
    request.fields["ext"] = (extension==null)?"uk":extension;
    await request.send();
  }


  Future<Uint8List> downloadFile(fileModel.File file) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString("user");
    String? url = prefs.getString("url");
    if(userString==null) throw PrefsException("User not set", "");
    if(url==null) throw PrefsException("Url not set", "");
    User user = User.fromJson(userString);
    if(user.token==null) throw ArbitraryException("Token is null", "");
    HttpClient client = HttpClient();
    HttpClientRequest request = await client.getUrl(Uri.parse("$url/family/folder/file/download?path=${file.path}"));
    request.headers.add("token", user.token!);
    HttpClientResponse response = await request.close();
    return await consolidateHttpClientResponseBytes(response);
  }

  Future<void> deleteFile(fileModel.File file) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString("user");
    String? url = prefs.getString("url");
    if(userString==null) throw PrefsException("User not set", "");
    if(url==null) throw PrefsException("Url not set", "");
    User user = User.fromJson(userString);
    if(user.token==null) throw ArbitraryException("Token is null", "");
  }

  Future<void> requestPermissions(String savePath) async{
    PermissionStatus status = await Permission.storage.status;
    if(status.isPermanentlyDenied) {
      throw ArbitraryException("Permissions permanently denied",
        "");
    }
    status = await Permission.manageExternalStorage.request();
    if(!status.isGranted){
      throw ArbitraryException("Denied", "");
    }
    Directory directory;
    if(Platform.isAndroid){
      directory = Directory("${Resources.downloadPath}/$savePath");
    }else{
      directory = await getApplicationDocumentsDirectory();
    }
    directory.createSync(recursive: true);
  }
}
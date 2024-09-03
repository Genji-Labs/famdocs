import 'dart:convert';

import 'package:famdocs/exceptions/arbitrary_exception.dart';
import 'package:famdocs/exceptions/prefs_exception.dart';
import 'package:famdocs/models/folder.dart';
import 'package:famdocs/models/user.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/dashboard_blocs/load_folder_contents_bloc.dart';

class FolderRepository{

  Future<void> createFolder(Folder parent,String newFolderName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString("user");
    String? url = prefs.getString("url");
    if(userString==null || url==null) throw PrefsException("User or url is null", "");
    User user = User.fromJson(userString);
    if(user.token==null) throw ArbitraryException("user token not set", "");
    Response response = await post(Uri.parse("$url/family/folder/create"),
    headers: {"token":user.token!},
    body: jsonEncode({
      "name":newFolderName,
      "family_id":parent.familyId!.toInt(),
      "parent_folder_id":parent.id!.toInt()
    }));
  }

  Future<FolderContents> getFolderContents(Folder folder) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString("user");
    String? url = prefs.getString("url");
    if(userString==null || url==null) throw PrefsException("User or url is null", "");
    User user = User.fromJson(userString);
    if(user.token==null) throw ArbitraryException("user token not set", "");
    Response response = await get(Uri.parse("$url/family/folder/get-contents?folder_id=${folder.id!.toInt()}"),
        headers: {"token":user.token!});
    return FolderContents.fromJson(response.body,folder);
  }
}
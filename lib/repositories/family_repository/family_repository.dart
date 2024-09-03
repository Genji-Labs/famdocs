import 'dart:convert';

import 'package:famdocs/exceptions/prefs_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/family.dart';
import '../../models/user.dart';

class FamilyRepository{

  Future<Family?> createFamily(Family family) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("user");
    String? url = prefs.getString("url");
    if(user==null) throw PrefsException("user is null","user is null");
    if(url==null) throw PrefsException("url is null", "");
    User userObject = User.fromJson(user);
    if(userObject.token==null) PrefsException("Token is null","");
    String token = userObject.token!;
    Response response = await post(Uri.parse("$url/family/create"),
        headers: {"token" : token,
        "Content-Type":"application/json"},
    body: jsonEncode({"user_id":userObject.userId!.toInt(),
    "family_name":family.familyName,
    "sha_hash":family.shaHash}));
    return Family.fromJson(response.body.toString());
  }

  Future<void> joinFamily(String joinCode,String password) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("user");
    String? url = prefs.getString("url");
    if(user==null) throw PrefsException("user is null","user is null");
    if(url==null) throw PrefsException("url is null", "");
    User userObject = User.fromJson(user);
    if(userObject.token==null) PrefsException("Token is null","");
    String token = userObject.token!;
    Response response = await post(Uri.parse("$url/family/join"),
        headers: {"token" : token,
          "Content-Type":"application/json"},
        body: jsonEncode({"user_id":userObject.userId!.toInt(),
          "join_code":joinCode,
          "password":password}));
    if(kDebugMode) print(response.body);
  }

}
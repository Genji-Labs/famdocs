import 'dart:convert';

import 'package:famdocs/models/family.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../exceptions/prefs_exception.dart';
import '../../models/user.dart';

class UserRepository{

  Future<List<Family>?> getFamilies() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("user");
    String? url = prefs.getString("url");
    if(user==null) throw PrefsException("user is null","user is null");
    if(url==null) throw PrefsException("url is null", "");
    User userObject = User.fromJson(user);
    if(userObject.token==null) PrefsException("Token is null","");
    String token = userObject.token!;
    Response response = await get(Uri.parse("$url/user/get-families"),
        headers: {"token" : token});
    List<Family> families = List.empty(growable: true);
    List? decodedList = jsonDecode(response.body);
    if(decodedList==null) return families;
    for(var family in decodedList){
      families.add(Family.fromJson(jsonEncode(family)));
    }
    return families;
  }

}
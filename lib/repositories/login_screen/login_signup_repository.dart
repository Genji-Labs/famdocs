import 'dart:convert';

import 'package:famdocs/exceptions/prefs_exception.dart';
import 'package:famdocs/models/user.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSignupRepository{

  Future<User> login(String phone,String otp,String token) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? url = prefs.getString("url");
      if(url==null || url.trim().isEmpty) throw "Url empty";
      Response response = await get(Uri.parse("$url/auth/login?phone=$phone&token=$token&otp=$otp"));
      User user = User.fromJson(response.body);
      return user;
  }

  Future<User> signup(String phone,String token,int avatar,String name) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? url = prefs.getString("url");
      if(url==null || url.trim().isEmpty) throw PrefsException("url empty","");
      Response response = await post(Uri.parse("$url/auth/signup"),
      body: jsonEncode(
        {"name":name,"phone":phone,"token":token,"avatar":avatar}),
      headers: {"Content-Type":"application/json"});
      User user = User.fromJson(response.body);
      return user;
  }
}
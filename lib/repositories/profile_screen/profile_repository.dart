
import 'package:famdocs/exceptions/prefs_exception.dart';
import 'package:famdocs/models/user.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository{
  
  Future<User?> getUser() async{
    Response? response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("user");
    String? url = prefs.getString("url");
    if(user==null) throw PrefsException("User is null", "");
    if(url==null) throw PrefsException("Url is null", "");
    User userObject = User.fromJson(user);
    if(userObject.token==null) PrefsException("Token is null","");
    String token = userObject.token!;
    response = await get(Uri.parse("$url/user/get"),
        headers: {"Content-Type":"application/json",
          "token" : token});
    return User.fromJson(response.body.toString());
    }

    Future<User> getUserFromPrefs() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? user = prefs.getString("user");
      if(user==null) throw PrefsException("User is null", "");
      return User.fromJson(user);
    }
}
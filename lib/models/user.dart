import 'dart:convert';

class User{
  BigInt? userId;
  String? phone;
  String? token;
  String? name;
  int? avatarId;
  User(this.userId,this.phone,this.token,this.name,this.avatarId);
  User.fromJson(String json){
    Map<String,dynamic> userData = jsonDecode(json);
    phone = userData["phone"];
    token = userData["token"];
    name = userData["name"];
    userId = BigInt.parse(userData["user_id"].toString());
    avatarId = int.parse(userData["avatar"].toString());
  }

  String toJson(){
    if(phone==null || token==null || name==null || avatarId==null || userId==null) throw "User is null";
    return jsonEncode({"phone":phone!,"token":token!,"name":name!,"avatar":avatarId,"user_id":userId.toString()});
  }
}
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository{

  void sendOtp(String phone,Function(String token,int? id,) codeSentCallback,
      Function(String error) failedCallback) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(phoneNumber: "+91$phone",
        verificationCompleted:(p){},
        verificationFailed: (err){},
        codeSent: codeSentCallback,
        codeAutoRetrievalTimeout: (e){});
  }
}
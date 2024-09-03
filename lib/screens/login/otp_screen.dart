import 'package:famdocs/bloc/login_screen_blocs/otp_textfield_validator_bloc.dart';
import 'package:famdocs/bloc/login_screen_blocs/otp_verifier_bloc.dart';
import 'package:famdocs/common/resources.dart';
import 'package:famdocs/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/app_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocus = List.generate(6,(index) => FocusNode());
  String? phone;
  String? token;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    phone = args["phone"];
    token = args["token"];
    return PopScope(onPopInvoked: onBackPressed,
      child: SafeArea(child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(padding: EdgeInsets.all(20.w),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => OtpVerifierBloc(OtpVerificationState("",false))),
            BlocProvider(create: (context) => OtpTextFieldValidatorBloc(false))
          ],
          child: BlocConsumer<OtpVerifierBloc,OtpVerificationState>(
            listener: (context,curr) async{
              if(curr.success) {
                if(curr.user!.userId!=BigInt.zero){
                  await storeUserAndToken(curr.user!);
                  Navigator.pushReplacementNamed(context, "/dashboard");
                  return;
                }
                Navigator.pushReplacementNamed(context, "/avatar_and_name",
              arguments: curr.user);
              }
            },
            listenWhen: (prev,curr) => curr.success,
            builder: (context,state){
              if(state.success) return onSuccess();
              return otpBody(context,state);
            },
          ),
        ),),
      )),
    );
  }

  Widget otpBody(BuildContext context,OtpVerificationState state){
    return Column(children: [
      headText(),
      SizedBox(height: 20.h,),
      otpFields(context),
      SizedBox(height:20.h),
      submitButton(state)
    ],);
  }

  Widget headText(){
    return Column(mainAxisSize: MainAxisSize.min,
      children: [
        Text("Verifying your number",style:Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 35.sp,fontWeight: FontWeight.w900)),
        SizedBox(height: 10.h,),
        Text("We have sent you a otp at +91-\n$phone.",
          style: Theme.of(context).textTheme.bodySmall?.
          copyWith(fontSize: 16.sp,
            fontWeight: FontWeight.w300,),
          textAlign: TextAlign.center,),
      ],);
  }

  Widget otpFields(BuildContext subContext){
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _otpControllers.map((e){
      return otpContainer(_otpControllers.indexOf(e),subContext);
    }).toList(),);
  }

  Widget otpContainer(int index,BuildContext subContext){
    return Container(height: 60.h,width: 60.w,
    padding: EdgeInsets.all(6.w),
    child: TextField(onChanged: (text) => changeHandler(text,index,subContext),
        maxLength: 1,focusNode: _otpFocus[index],
      controller: _otpControllers[index],
      style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 18.sp,),
      textAlign: TextAlign.center,
      decoration:
    InputDecoration(counterText: "",fillColor: Theme.of(context).hoverColor,
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 1.w),
      borderRadius: BorderRadius.circular(10.r))
    ),
    ),);
  }


  Widget submitButton(OtpVerificationState verificationState){
    return BlocBuilder<OtpTextFieldValidatorBloc,bool>(
      builder: (context,state){
      return IgnorePointer(ignoring: !state,//,
        child: AppButton(size: Size(MediaQuery.of(context).size.width,60.h), onPressed: () => verifyOtp(context),
          color: (!state)?Colors.grey:Resources.mainBlue, child:
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Verify OTP",style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18.sp,
                  fontWeight: FontWeight.w500),),
              SizedBox(width: 10.w,),
              SizedBox(width: 20.w,height: 20.w,
                child: Visibility(visible: verificationState.showLoader==true,
                    child: const CircularProgressIndicator(color: Colors.white,)),
              )
            ],
          ),),
      );
      },
    );
  }


  Widget onSuccess(){
    return Container();
  }

  void changeHandler(String text,int index,BuildContext subContext){
    if(text.isEmpty && index>0) {_otpFocus[index-1].requestFocus(); return;}
    if(text.isNotEmpty && index<5) {_otpFocus[index+1].requestFocus(); return;}
    if(index==5){
      String otp = "";
      for(TextEditingController controller in _otpControllers) {
        otp += controller.text.trim();
      }
      subContext.read<OtpTextFieldValidatorBloc>().check(otp);
    }
  }

  void verifyOtp(BuildContext subContext){
    subContext.read<OtpVerifierBloc>().showLoader();
    String otp = "";
    for(TextEditingController controller in _otpControllers) {
      otp += controller.text.trim();
    }
    subContext.read<OtpVerifierBloc>().verify(phone!, otp, token!);
  }

  void onBackPressed(bool canPop) async{
    await showGeneralDialog(context: context, pageBuilder: (context,anim1,anim2){
      return Container();
    });
  }

  Future<void> storeUserAndToken(User user) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", user.toJson());
    prefs.setString("token", user.token.toString());
  }
}

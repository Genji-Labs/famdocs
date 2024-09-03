import 'package:famdocs/bloc/login_screen_blocs/phone_textfield_validator_bloc.dart';
import 'package:famdocs/common/app_button.dart';
import 'package:famdocs/common/resources.dart';
import 'package:famdocs/repositories/login_screen/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool keyboardSwitchTrigger = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
    backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: bodyStack()
        ),
      ),
    ));
  }

  Widget bodyStack(){
    return Stack(children: [
      lottieAnimation(),
      BlocProvider(create: (context)=>PhoneTextFieldValidatorBloc(TextFieldState(true,"")),
          child: phonePage())
    ],);
  }

  Widget lottieAnimation(){
    return Align(alignment: Alignment.topCenter
    ,child: LottieBuilder.asset("assets/lottie/login_animation.json",reverse: true,));
  }

  Widget privacyPolicy(){
    return Center(child: Text("Privacy Policy",
    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.sp,
    fontWeight: FontWeight.w300),),);
  }

  Widget phonePage(){
    return SizedBox(height: MediaQuery.of(context).size.height-
      MediaQuery.of(context).padding.top-
      MediaQuery.of(context).padding.bottom-40.w,
      child: Align(alignment: Alignment.bottomCenter,
        child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,children: [
          Text("Welcome!\nLet's get started",style:Theme.of(context).textTheme.headlineLarge?.
          copyWith(fontSize: 35.sp,fontWeight: FontWeight.w900)),
          SizedBox(height: 10.h,),
          Text("We are extremely happy to get you onboard,\nbut first let's get some deets.",
            style: Theme.of(context).textTheme.bodySmall?.
          copyWith(fontSize: 16.sp,
            fontWeight: FontWeight.w300,),
          textAlign: TextAlign.start,),
          SizedBox(height: 40.h,),
          phonePageFields(),
          SizedBox(height: 20.h,),
        BlocBuilder<PhoneTextFieldValidatorBloc,TextFieldState>(
            builder: (context,state){
              if(keyboardSwitchTrigger && !state.error){
                FocusManager.instance.primaryFocus?.unfocus();
                keyboardSwitchTrigger = false;
              }
                return IgnorePointer(ignoring: state.error,
                  child: AppButton(size: Size(MediaQuery.of(context).size.width,60.h),
                    onPressed: () => sendOtp(context),
                    color: (state.error)?Colors.grey:Resources.mainBlue, child:
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Send OTP",style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18.sp,
                          fontWeight: FontWeight.w500),),
                      SizedBox(width: 10.w,),
                      SizedBox(width: 20.w,height: 20.w,
                        child: Visibility(visible: state.showLoader==true,
                        child: const CircularProgressIndicator(color: Colors.white,)),
                      )
                    ],
                  ),),
                );
            }
        ),
          SizedBox(height: 70.h,),
          privacyPolicy(),
          SizedBox(height: 40.h,)
        ],),
      ),
    );
  }

  Widget phonePageFields(){
    return Column(mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("\t\tMobile Number",style: Theme.of(context).textTheme.headlineLarge?.
      copyWith(fontSize: 18.sp,
      fontWeight: FontWeight.bold),),
      SizedBox(height: 8.h,),
      BlocBuilder<PhoneTextFieldValidatorBloc,TextFieldState>(
        builder: (context,state){
          return TextField(maxLength: 10,
            onChanged: (text) => validatePhone(text,context),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 20.sp,
              letterSpacing: 0.8.w,
              fontWeight: FontWeight.w400
            ),
            cursorColor: Theme.of(context).secondaryHeaderColor,
            cursorErrorColor: Theme.of(context).secondaryHeaderColor,
            decoration: InputDecoration(
              counterText: "",
                hintText: "0000000000",
              hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 20.sp,
                  letterSpacing: 0.8.w,
                  fontWeight: FontWeight.w400
              ),
              filled: true,
              errorStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.redAccent,
                fontSize: 14.sp
              ),
              prefixIcon: phoneFieldPrefixIcon(),
              errorText: state.message,
              fillColor: Theme.of(context).hoverColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none)),
            keyboardType: TextInputType.phone,
            controller: _phoneController,);
        },
      )
    ],);
  }

  Widget phoneFieldPrefixIcon(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("+91\t\t",
          style:
          Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 20.sp,
              letterSpacing: 0.8.w,
              fontWeight: FontWeight.w400
          ),),
      ],
    );
  }

  void validatePhone(String phone,BuildContext subContext){
    keyboardSwitchTrigger = true;
    subContext.read<PhoneTextFieldValidatorBloc>().check(phone);
  }


  void sendOtp(BuildContext subContext){
    subContext.read<PhoneTextFieldValidatorBloc>().showLoader();
    String phone = _phoneController.text;
    if(phone.trim().isEmpty || phone.trim().length!=10) return;
    FirebaseRepository repo = FirebaseRepository();
    repo.sendOtp(phone, (token,_){
      Navigator.pushNamed(context, "/otp",arguments: {"phone":phone,"token":token});
    },(err){
    });
  }
}

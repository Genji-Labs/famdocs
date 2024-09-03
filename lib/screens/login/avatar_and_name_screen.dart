import 'package:famdocs/bloc/login_screen_blocs/avatar_selector_bloc.dart';
import 'package:famdocs/bloc/login_screen_blocs/phone_textfield_validator_bloc.dart';
import 'package:famdocs/bloc/login_screen_blocs/signup_bloc.dart';
import 'package:famdocs/common/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/login_screen_blocs/name_textfield_validator_bloc.dart';
import '../../common/app_button.dart';
import '../../models/user.dart';

class AvatarAndNameScreen extends StatefulWidget {
  const AvatarAndNameScreen({super.key});

  @override
  State<AvatarAndNameScreen> createState() => _AvatarAndNameScreenState();
}

class _AvatarAndNameScreenState extends State<AvatarAndNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  User? user;
  int avatar = 1;
  String name = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)!.settings.arguments as User;
    return SafeArea(child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(padding: EdgeInsets.all(20.w),
      child: SingleChildScrollView(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AvatarSelectorBloc(0)),
            BlocProvider(create: (context) => SignupBloc(SignupBlocState(false))),
            BlocProvider(create: (context) => NameTextFieldValidatorBloc(TextFieldState(true,"")))
          ],
            child: BlocConsumer<SignupBloc,SignupBlocState>(
              listener: (context,state) async{
                if(state.user==null) return;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("user", state.user!.toJson());
                if(context.mounted) Navigator.pushNamedAndRemoveUntil(context, "/dashboard", (route) => false);
              },
              listenWhen: (prev,curr) => curr.success,
              builder: (context,state){
                return Column(children: [
                  SizedBox(height: 50.h,),
                  headText(),
                  SizedBox(height: 50.h,),
                  avatarGrid(),
                  SizedBox(height: 20.h,),
                  nameFieldAndSubmitButton(context),
                ],);
              },
          ),
        ),
      ),),
    ));
  }

  Widget headText(){
    return Column(mainAxisSize: MainAxisSize.min,
      children: [
        Text("Select an avatar",style:Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 35.sp,fontWeight: FontWeight.w900)),
        SizedBox(height: 10.h,),
        Text("You are almost done!\nJust need a name and an avatar for your profile.",
          style: Theme.of(context).textTheme.bodySmall?.
          copyWith(fontSize: 16.sp,
            fontWeight: FontWeight.w300,),
          textAlign: TextAlign.center,),
      ],);
  }

  Widget avatarGrid(){
    return BlocBuilder<AvatarSelectorBloc,int>(
      builder: (context,state){
        return SizedBox(height: 200.h,
          child: GridView.builder(gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5,mainAxisSpacing: 20.h,
              crossAxisSpacing: 20.h), itemBuilder: (context,index){
            return avatarCircle(index,state,context);
          },itemCount: Resources.avatars.length,),);
      }
    );
  }

  Widget avatarCircle(int index,int selectedIndex,BuildContext subContext){
    return GestureDetector(onTap: (){
      avatar = index+1;
      subContext.read<AvatarSelectorBloc>().updateSelection(index);
      },
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle,
        color: (index==selectedIndex)?Resources.mainBlue:null),
      padding: EdgeInsets.all(4.w),child: CircleAvatar(backgroundImage:
      AssetImage(Resources.avatars[index]),
      backgroundColor: Theme.of(context).secondaryHeaderColor,)),
    );
  }

  Widget nameFieldAndSubmitButton(BuildContext subContext){
    return  BlocBuilder<NameTextFieldValidatorBloc,TextFieldState>(
      builder: (context,state){
        return Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("\t\tYour Name",style: Theme.of(context).textTheme.headlineLarge?.
            copyWith(fontSize: 18.sp,
                fontWeight: FontWeight.bold),),
            SizedBox(height: 8.h,),
            TextField(maxLength: 20,
              onChanged: (text) => validate(text,context),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 20.sp,
                  letterSpacing: 0.8.w,
                  fontWeight: FontWeight.w400
              ),
              cursorColor: Theme.of(context).secondaryHeaderColor,
              cursorErrorColor: Theme.of(context).secondaryHeaderColor,
              decoration: InputDecoration(
                  hintText: "Ankit",
                  counterText: "",
                  hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 20.sp,
                      letterSpacing: 0.8.w,
                      fontWeight: FontWeight.w400
                  ),
                  errorStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.redAccent,
                      fontSize: 14.sp
                  ),
                  errorText: state.message,
                  filled: true,
                  fillColor: Theme.of(context).hoverColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide.none)),
              controller: _nameController,),
            SizedBox(height: 20.h,),
            submitButton(state,subContext)
          ],
        );
      }
    );
  }

  Widget submitButton(TextFieldState state,BuildContext subContext){
    return IgnorePointer(ignoring: state.error,
      child: AppButton(size: Size(MediaQuery.of(context).size.width,60.h),
        onPressed: () => uploadAvatarAndName(subContext),
        color: (state.error)?Colors.grey:Resources.mainBlue, child:
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Let's Go",style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18.sp,
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

  void validate(String name,BuildContext subContext) => subContext.read<NameTextFieldValidatorBloc>().check(name);

  void uploadAvatarAndName(BuildContext subContext) async{
    subContext.read<SignupBloc>().showLoader();
    name = _nameController.text.trim();
    subContext.read<SignupBloc>().signup(user!.phone!, user!.token!, avatar, name);
  }

}

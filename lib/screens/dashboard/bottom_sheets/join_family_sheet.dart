import 'package:famdocs/bloc/dashboard_blocs/join_family_form_bloc.dart';
import 'package:famdocs/common/app_button.dart';
import 'package:famdocs/repositories/family_repository/family_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/resources.dart';

class JoinFamilySheet extends StatefulWidget {
  const JoinFamilySheet({super.key});

  @override
  State<JoinFamilySheet> createState() => _JoinFamilySheetState();
}

class _JoinFamilySheetState extends State<JoinFamilySheet> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20.w),
      child: RepositoryProvider(create: (context) => FamilyRepository(),
        child: BlocProvider(create: (context) => JoinFamilyFormBloc(ValidateState(true,"",true,""),context),
          child: BlocConsumer<JoinFamilyFormBloc,JoinFamilyFormState?>(listener: (context,state){
            Navigator.pop(context,true);
          },listenWhen: (prev,curr) => (curr is SuccessState),
            builder: (context,state){
            return Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 3),
                  child: Column(children: [
                    titleText(),
                    SizedBox(height: 30.h,),
                    codeField(state as ValidateState,context),
                    note(),
                    SizedBox(height: 20.h,),
                    passwordField(state,context),
                    SizedBox(height: 10.h,),
                    joinButton(state,context),
                    SizedBox(height:20.h),
                  ],),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(onPressed: (){Navigator.pop(context);}, icon:
                    const Icon(Icons.cancel)),
                  ),
                )
              ],
            );
          },buildWhen: (prev,curr) => curr is! SuccessState,)
        ),
      ),);
  }

  Widget titleText(){
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(width: 100.w,height: 6.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.r),
              color: Colors.grey),),
        SizedBox(height: 10.h,),
        Text("Join Family",style:Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 33.sp,fontWeight: FontWeight.w900)),
      ],);
  }

  Widget note(){
    return Text("Note : Family password will be required in the next step. Please contact the family owner or a member if you don't have the password. Alternatively, the family owner can also manually add you to the family by going in the family settings screen.",
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 15.sp
      ),);
  }

  Widget codeField(ValidateState state,BuildContext context){
    return Column(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("\t\tFamily Code",style: Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 18.sp,
            fontWeight: FontWeight.bold),),
        SizedBox(height: 8.h,),
        TextField(maxLength: 6,
          canRequestFocus: true,
          inputFormatters: [
            TextInputFormatter.withFunction((oldVal,newVal){
              return TextEditingValue(text: newVal.text.toUpperCase());
            })
          ],
          controller: _codeController,
          onChanged: (code){ BlocProvider.of<JoinFamilyFormBloc>(context).validate(code,
              _passwordController.text); },
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 20.sp,
              letterSpacing: MediaQuery.of(context).size.width/12,
              fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          cursorColor: Theme.of(context).secondaryHeaderColor,
          cursorErrorColor: Theme.of(context).secondaryHeaderColor,
          decoration: InputDecoration(
              hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 20.sp,
                  letterSpacing: MediaQuery.of(context).size.width/12,
                  fontWeight: FontWeight.w400
              ),
              filled: true,
              error: Text(state.codeMessage),
              errorStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.redAccent,
                  fontSize: 14.sp
              ),
              fillColor: Theme.of(context).hoverColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none)),)
      ],);
  }

  Widget passwordField(ValidateState state,BuildContext context){
    return Visibility(visible: !state.codeError,
      child: Column(mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("\t\tFamily Password",style: Theme.of(context).textTheme.headlineLarge?.
          copyWith(fontSize: 18.sp,
              fontWeight: FontWeight.bold),),
          SizedBox(height: 8.h,),
          TextField(maxLength: 10,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 20.sp,
                letterSpacing: 0.8.w,
                fontWeight: FontWeight.w400
            ),
            controller: _passwordController,
            onChanged: (password) {
            BlocProvider.of<JoinFamilyFormBloc>(context).validate(_codeController.text,
                password); },
            cursorColor: Theme.of(context).secondaryHeaderColor,
            cursorErrorColor: Theme.of(context).secondaryHeaderColor,
            obscureText: true,
            decoration: InputDecoration(
                counterText: "",
                hintText: "*************",
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
                error: Text(state.passwordMessage),
                fillColor: Theme.of(context).hoverColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none)),
            keyboardType: TextInputType.visiblePassword,)
        ],),
    );
  }

  Widget joinButton(ValidateState state,BuildContext context){
    return IgnorePointer(ignoring: (state.codeError || state.passwordError),
      child: AppButton(size: Size(MediaQuery.of(context).size.width,60.h), onPressed:() async{
        BlocProvider.of<JoinFamilyFormBloc>(context).joinFam(
          RepositoryProvider.of<FamilyRepository>(context),
          _codeController.text.trim(),
          _passwordController.text.trim()
        );
      },
        color: (state.codeError || state.passwordError)?Colors.grey:Resources.mainBlue, child:
        Text("Next",style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18.sp,
            fontWeight: FontWeight.w500),),),
    );
  }
}

import 'dart:convert';

import 'package:famdocs/bloc/dashboard_blocs/validate_create_family_form_bloc.dart';
import 'package:famdocs/common/app_button.dart';
import 'package:famdocs/models/family.dart';
import 'package:famdocs/repositories/family_repository/family_repository.dart';
import 'package:famdocs/services/encryption/bin2hex.dart';
import 'package:famdocs/services/encryption/sha_hasher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pointycastle/export.dart' as pointy;
import '../../../common/resources.dart';

class CreateFamilySheet extends StatefulWidget {
  const CreateFamilySheet({super.key});

  @override
  State<CreateFamilySheet> createState() => _CreateFamilySheetState();
}

class _CreateFamilySheetState extends State<CreateFamilySheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20.w),
      child: Stack(
        children: [
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ValidateCreateFamilyFormBloc(CreateFamilyFormState(true,["","",""]))),
            ],
            child: BlocBuilder<ValidateCreateFamilyFormBloc,CreateFamilyFormState>(
                builder: (context,formState){
                  return Column(children: [
                    titleText(),
                    SizedBox(height: 30.h,),
                    nameAndPasswordFields(formState,context),
                    SizedBox(height:10.h),
                    createButton(formState,context),
                    SizedBox(height:20.h),
                  ],);
                }
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(onPressed: (){Navigator.pop(context);}, icon:
              const Icon(Icons.cancel)),
            ),
          )
        ],
      ),);
  }

  Widget titleText(){
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Container(width: 100.w,height: 6.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.r),
      color: Colors.grey),),
        SizedBox(height: 10.h,),
        Text("Create Family",style:Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 33.sp,fontWeight: FontWeight.w900)),
    ],);
  }

  Widget nameAndPasswordFields(CreateFamilyFormState state,BuildContext subContext){
    return Column(
      children: [
        nameField(state,subContext),
        SizedBox(height: 25.h,),
        Text("Note : The following family password can only be set once. Your family members will have to enter this password once upon login or while joining the family via invite. Changing this password might take some time (usually 30-40 minutes). We do not store this password on any of our servers for privacy reasons, so we advise you to write it down in a secure location.",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 15.sp
          ),),
        SizedBox(height: 10.h,),
        passwordField(state,subContext),
        SizedBox(height: 10.h,),
        confirmPasswordField(state,subContext)
      ],
    );
  }

  Widget nameField(CreateFamilyFormState state,BuildContext subContext){
    return Column(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("\t\tFamily Name",style: Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 18.sp,
            fontWeight: FontWeight.bold),),
        SizedBox(height: 8.h,),
        TextField(maxLength: 10,
          onChanged: (text) => validator(subContext),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 20.sp,
              letterSpacing: 0.8.w,
              fontWeight: FontWeight.w400
          ),
          controller: _nameController,
          cursorColor: Theme.of(context).secondaryHeaderColor,
          cursorErrorColor: Theme.of(context).secondaryHeaderColor,
          decoration: InputDecoration(
              counterText: "",
              hintText: "The Rana's",
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
              errorText: state.messages[0],
              fillColor: Theme.of(context).hoverColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none)),)
      ],);
  }

  Widget passwordField(CreateFamilyFormState state,BuildContext subContext){
    return Column(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("\t\tFamily Password",style: Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 18.sp,
            fontWeight: FontWeight.bold),),
        SizedBox(height: 8.h,),
        TextField(maxLength: 10,
          controller: _passwordController,
          onChanged: (text) => validator(subContext),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 20.sp,
              letterSpacing: 0.8.w,
              fontWeight: FontWeight.w400
          ),
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
              errorText: state.messages[1],
              fillColor: Theme.of(context).hoverColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none)),
          keyboardType: TextInputType.visiblePassword,)
      ],);
  }

  Widget confirmPasswordField(CreateFamilyFormState state,BuildContext subContext){
    return Column(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("\t\tConfirm Password",style: Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 18.sp,
            fontWeight: FontWeight.bold),),
        SizedBox(height: 8.h,),
        TextField(maxLength: 10,
          controller: _confirmPasswordController,
          obscureText: true,
          onChanged: (text) => validator(subContext),
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
              hintText: "************",
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
              errorText: state.messages[2],
              fillColor: Theme.of(context).hoverColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none)),
          keyboardType: TextInputType.visiblePassword,)
      ],);
  }

  Widget createButton(CreateFamilyFormState state,BuildContext subContext){
    return IgnorePointer(ignoring:state.error,
      child: AppButton(size: Size(MediaQuery.of(context).size.width,60.h), onPressed: () => createFamily(subContext),
        color: (state.error)?Colors.grey:Resources.mainBlue, child:
        Text("Create",style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18.sp,
            fontWeight: FontWeight.w500),),),
    );
  }

  void validator(BuildContext subContext){
    subContext.read<ValidateCreateFamilyFormBloc>().validate(_nameController.text,
        _passwordController.text, _confirmPasswordController.text);
  }

  void createFamily(BuildContext subContext) async{
    Resources.showAppLoader(context);
    Family family = Family(null, _nameController.text.trim(),
        null, hashIt(_passwordController.text),null);
    try{
      FamilyRepository repo = FamilyRepository();
      await repo.createFamily(family);
    }catch(e){
      if(kDebugMode) print(e);
    }finally{
      if(mounted){
        Resources.killAppLoader(context);
        Navigator.pop(context,true);
      }
    }
  }
}

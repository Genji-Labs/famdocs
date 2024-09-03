import 'dart:math';

import 'package:famdocs/database/password_database_helper.dart';
import 'package:famdocs/models/family.dart';
import 'package:famdocs/services/encryption/sha_hasher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/app_button.dart';
import '../../../common/resources.dart';

class FamilyPasswordSheet extends StatefulWidget {
  final Family family;
  const FamilyPasswordSheet({super.key,required this.family});

  @override
  State<FamilyPasswordSheet> createState() => _FamilyPasswordSheetState();
}

class _FamilyPasswordSheetState extends State<FamilyPasswordSheet> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20.w),
      child: Stack(
        children: [
          Column(children: [
            titleText(),
            SizedBox(height: 30.h,),
            passwordField(),
            SizedBox(height: 10.h,),
            joinButton(),
            SizedBox(height:20.h),
          ],),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon:
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
        SizedBox(height: 40.h,),
        Text("Enter Family Password for ${widget.family.familyName!}",style:Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 28.sp,fontWeight: FontWeight.w900)),
      ],);
  }

  Widget note(){
    return Text("Note : This is a one time step.",
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 15.sp
      ),);
  }

  Widget passwordField(){
    return Column(mainAxisSize: MainAxisSize.min,
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
              fillColor: Theme.of(context).hoverColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none)),
          keyboardType: TextInputType.visiblePassword,)
      ],);
  }

  Widget joinButton(){
    return IgnorePointer(ignoring: false,
      child: AppButton(size: Size(MediaQuery.of(context).size.width,60.h), onPressed:() async{
        if(hashIt(_passwordController.text.trim())!=widget.family.shaHash!){
          if(kDebugMode) print("Passwords do not match");
          return;
        }
        PasswordDatabaseHelper passwordDatabaseHelper = PasswordDatabaseHelper(1);
        await passwordDatabaseHelper.addPassword(widget.family.familyId!, _passwordController.text.trim());
        if(mounted) Navigator.pop(context);
      },
        color: (false)?Colors.grey:Resources.mainBlue, child:
        Text("Next",style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18.sp,
            fontWeight: FontWeight.w500),),),
    );
  }
}

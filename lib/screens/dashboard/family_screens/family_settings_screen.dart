import 'package:famdocs/models/family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FamilySettingsScreen extends StatefulWidget {
  final Family family;
  const FamilySettingsScreen({super.key,required this.family});

  @override
  State<FamilySettingsScreen> createState() => _FamilySettingsScreenState();
}

class _FamilySettingsScreenState extends State<FamilySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 50.h),
          child: Column(children: [
            appBar(),
            SizedBox(height: 20.h,),
          ],),),
      ),));
  }

  Widget appBar(){
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${widget.family.familyName} Settings",
            style:Theme.of(context).textTheme.headlineLarge?.
            copyWith(fontSize: 20.sp,fontWeight: FontWeight.w500)),
      ],
    );
  }
}

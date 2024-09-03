import 'dart:math';
import 'package:famdocs/bloc/dashboard_blocs/family_folder_switch.dart';
import 'package:famdocs/database/password_database_helper.dart';
import 'package:famdocs/models/family.dart';
import 'package:famdocs/models/folder.dart';
import 'package:famdocs/screens/dashboard/bottom_sheets/family_password_sheet.dart';
import 'package:famdocs/screens/dashboard/family_screens/content_screen.dart';
import 'package:famdocs/screens/dashboard/family_screens/family_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import '../../../common/resources.dart';
import '../../../services/password_entry_checker.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final TextEditingController _searchController = TextEditingController();
  Family? family;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20.h),
      child: BlocProvider(create:
          (context) => Resources.familySwitch = FamilySwitch(Resources.families[0]),
        child: BlocBuilder<FamilySwitch,Family>(
            builder: (context,fam){
              family = fam;
              return Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBar(),
                  SizedBox(height: 40.h,),
                  searchBar(),
                  SizedBox(height: 30.h,),
                  ContentScreen(key: Key(fam.familyId.toString()),family: fam,folder: fam.rootFolder!,)
                ],);
            }
        ),
      ),);
  }

  Widget appBar(){
    return Row(
      children: [
        //Hamburger
        GestureDetector(onTap: () => Resources.dashboardToSkeletonOpenDrawerBloc.open(Random().nextInt(100000)),
          child: Container(height: 44.h,width: 44.h,
            decoration: BoxDecoration(shape: BoxShape.circle,color: Theme.of(context).hoverColor),
            child: Center(child: SvgPicture.asset("assets/hamburger.svg",
              color: Theme.of(context).secondaryHeaderColor,
            ),),),
        ),
        Spacer(),
        //Family deets,
        Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            Text("Family",
              style: Theme.of(context).textTheme.bodySmall?.
              copyWith(fontSize: 16.sp,
                fontWeight: FontWeight.w300,),
              textAlign: TextAlign.center,),
            SizedBox(height: 10.h,),
            Text(family!.familyName!,
                style:Theme.of(context).textTheme.headlineLarge?.
                copyWith(fontSize: 20.sp,fontWeight: FontWeight.w500))
          ],),
        Spacer(),
        SizedBox(width: 5.w,),
        //Family settings
        GestureDetector(onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context){
          return FamilySettingsScreen(family:family!);
        })),
          child: Container(height: 44.h,width: 44.h,
            decoration: BoxDecoration(shape: BoxShape.circle,color: Theme.of(context).hoverColor),
            child: Center(child: Icon(Icons.settings,
              color: Theme.of(context).secondaryHeaderColor,),),),
        ),
      ],
    );
  }

  Widget searchBar(){
    return TextField(maxLength: 10,
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
          hintText: "Search by name or content in the file",
          hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.grey,
              fontSize: 20.sp,
              letterSpacing: 0.8.w,
              fontWeight: FontWeight.w400
          ),
          filled: true,
          prefixIcon: SizedBox(
              width: 30.w,child: const Icon(Icons.search)),
          fillColor: Theme.of(context).hoverColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide.none)),
      controller: _searchController,);
  }

  Widget folderTile(int index,Folder folder){
    return GestureDetector(onTap: (){},
      onLongPress: (){
      },
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,children: [
          SvgPicture.asset("assets/folder.svg",height: 80.h,width: 80.w,),
          SizedBox(height: 5.h,),
          Text(folder.name!,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.w400
          ),)
        ],),
    );
  }
}
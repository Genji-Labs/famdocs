
import 'dart:io';

import 'package:famdocs/bloc/dashboard_blocs/family_folder_switch.dart';
import 'package:famdocs/bloc/dashboard_blocs/load_families_bloc.dart';
import 'package:famdocs/bloc/theme_bloc.dart';
import 'package:famdocs/common/app_loader.dart';
import 'package:famdocs/models/family.dart';
import 'package:famdocs/models/pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/dashboard_blocs/skeleton_dashboard_bridges.dart';


class Resources {
  static String downloadPath = "/storage/emulated/0/Download/FamDocs";

  //Avatars
  static List<String> avatars = List.generate(10, (index){
    return "assets/avatars/av${index+1}.png";
  });
  static List<Family> families = List.empty(growable: true);

  //Common blocs
  static late FamilySwitch familySwitch;
  static late FolderSwitch folderSwitch;
  static final DashboardToSkeletonOpenDrawerBloc dashboardToSkeletonOpenDrawerBloc = DashboardToSkeletonOpenDrawerBloc(0);
  static final SkeletonToDashboardSwitchPageBloc skeletonToDashboardSwitchPageBloc = SkeletonToDashboardSwitchPageBloc(PageDataObject(Pages.home));
  static late LoadFamiliesBloc loadFamiliesBloc;

  //Themes
  static ThemeBloc themeBloc = ThemeBloc(ThemeMode.system);
  static Color mainBlue = const Color(0xff5B9EE1);
  static ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xff1A2530),
    hoverColor: const Color(0xff161F28),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xff1A2530)),
    textTheme: TextTheme(bodySmall: GoogleFonts.roboto(
      color: const Color(0xff707B81),
    ),headlineLarge: GoogleFonts.roboto( color: Colors.white)),
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(mainBlue),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r))
      )
    )),
    iconButtonTheme: IconButtonThemeData(style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(const Color(0xff161F28)),
      iconColor: WidgetStateProperty.all(Colors.white)
    ))
  );

  static ThemeData lightTheme = ThemeData(primaryColor: const Color(0xffF8F9FA),
  appBarTheme: const AppBarTheme(backgroundColor: Color(0xffF8F9FA)),
      textButtonTheme: TextButtonThemeData(style: ButtonStyle(
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)))
      )),
      textTheme: TextTheme(bodySmall: GoogleFonts.roboto(
          color: const Color(0xff707B81)
      ),headlineLarge: GoogleFonts.roboto( color: const Color(0xff1A2530))),
      iconButtonTheme: IconButtonThemeData(style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          iconColor: WidgetStateProperty.all(const Color(0xff161F28))
      ))
  );


  static bool isShowingLoader = false;
  //Functions

  static showAppLoader(BuildContext context) async{
    if(kDebugMode) print("loading${context.hashCode}");
    await Future.delayed(const Duration(seconds: 1),(){
      showGeneralDialog(context: context,
          barrierDismissible: false,
          pageBuilder: (context,anim1,anim2){
            return const AppLoader();
          });
      isShowingLoader = true;
    });
  }

  static killAppLoader(BuildContext context){
    if(kDebugMode) print("killing@${context.hashCode}");
    if(isShowingLoader==false) return;
    Navigator.pop(context);
    isShowingLoader = false;
  }
}


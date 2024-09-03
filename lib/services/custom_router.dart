import 'package:famdocs/screens/dashboard_skeleton.dart';
import 'package:famdocs/screens/login/otp_screen.dart';
import 'package:famdocs/screens/login/phone_screen.dart';
import 'package:famdocs/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../screens/login/avatar_and_name_screen.dart';
import '../screens/splash_screen.dart';

Route getRoute(RouteSettings settings){
  switch(settings.name){
    case "/splash":
      return MaterialPageRoute(builder: (context){
        return const SplashScreen();
      },settings: settings);
    case "/welcome":
      return MaterialPageRoute(builder: (context){
        return const WelcomeScreen();
      },settings: settings);
    case "/dashboard":
      return MaterialPageRoute(builder: (context){
        return const DashboardSkeleton();
      },settings: settings);
    case "/login":
      return MaterialPageRoute(builder: (context){
        return const LoginScreen();
      },settings:settings);
    case "/otp":
      return MaterialPageRoute(builder: (context){
        return const OtpScreen();
      },settings: settings);
    case "/avatar_and_name":
      return MaterialPageRoute(builder: (context){
        return const AvatarAndNameScreen();
      },settings: settings);
    default:
      return MaterialPageRoute(builder: (context){return Container();},
       settings: settings);
  }
}
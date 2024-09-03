import 'package:famdocs/common/resources.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController lottieController;
  @override
  void initState() {
    lottieController = AnimationController(vsync: this,duration: const Duration(seconds: 2,milliseconds: 100));
    lottieController.forward();
    Future.delayed(const Duration(seconds: 3),() => preChecks());
    super.initState();
  }

  preChecks() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = (kDebugMode)?"http://192.168.31.6:8000":"http://152.42.156.5:8000";
    prefs.setString("url", url);
    if(prefs.containsKey("theme")){
      switch((prefs.getString("theme")).toString()){
        case "dark":
          Resources.themeBloc.switchTo(ThemeMode.dark);
          break;
        case "light":
          Resources.themeBloc.switchTo(ThemeMode.light);
          break;
      }
    }
    if(!prefs.containsKey("user") && mounted){
      Navigator.pushReplacementNamed(context, "/welcome");
    }else if(mounted){
      Navigator.pushReplacementNamed(context, "/dashboard");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(backgroundColor: Theme.of(context).primaryColor,
    body: Center(
      child: LottieBuilder.asset("assets/lottie/splash_animation.json",repeat: false,
        controller: lottieController,
      )
    ),));
  }
}

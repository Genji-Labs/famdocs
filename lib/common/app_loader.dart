import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      child: BackdropFilter(filter: ImageFilter.blur(
        sigmaY: 3,
        sigmaX: 3
      ),child:
        Center(child: SizedBox(height:70.w,width: 70.w,
            child: LottieBuilder.asset("assets/lottie/loading_animation.json")),),),
    );
  }
}

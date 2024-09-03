import 'package:famdocs/bloc/welcome_screen_blocs/viewpage_bloc.dart';
import 'package:famdocs/common/app_button.dart';
import 'package:famdocs/common/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final int PAGE_COUNT = 2;
  PageController pageViewController = PageController();
  final ViewPagerBloc _pagerBloc = ViewPagerBloc(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pagerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(backgroundColor: Theme.of(context).primaryColor,
    body: Padding(
      padding: EdgeInsets.only(left: 10.w,right: 10.w,top: 60.h),
      child: Column(children: [
        viewPager(),
        nextButton()
      ],),
    ),));
  }

  Widget viewPager(){
    return Expanded(flex: 7,
      child: PageView.builder(itemBuilder: (context,position){
        switch(position){
          case 0:
            return pageOne();
          case 1:
            return pageTwo();
          default:
            return Container();
        }
      },itemCount: PAGE_COUNT, onPageChanged: (position){
        _pagerBloc.jumpTo(position);
      },
      controller: pageViewController,),
    );
  }

  Widget pageOne(){
    return Padding(
      padding: EdgeInsets.only(left: 40.w,right: 40.w),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset("assets/lottie/welcome_family.json"),
          SizedBox(height: 50.h,),
          Text("Built for your Family\n",style:Theme.of(context).textTheme.headlineLarge?.
          copyWith(fontSize: 35.sp,fontWeight: FontWeight.w900)),
          Text("Devs at Genji Labs built this app for their \nown families and we would be super happy to\nsee "
              "your family join in.",
            style: Theme.of(context).textTheme.bodySmall?.
            copyWith(fontSize: 18.sp,
              fontWeight: FontWeight.w300,),
            textAlign: TextAlign.center,)
        ],
      ),
    );
  }

  Widget pageTwo(){
    return Padding(
      padding: EdgeInsets.only(left: 40.w,right: 40.w),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset("assets/lottie/welcome_secure.json"),
          SizedBox(height: 50.h,),
          Text("We Encrypt!\n",style:Theme.of(context).textTheme.headlineLarge?.
          copyWith(fontSize: 35.sp,fontWeight: FontWeight.w900)),
          Text("We take privacy very seriously at Genji Labs.\n"
              "We use AES-CBC 256 bit encryption for all your documents.\nThe encryption key NEVER leaves your device.",
            style: Theme.of(context).textTheme.bodySmall?.
            copyWith(fontSize: 16.sp,
              fontWeight: FontWeight.w300,),
            textAlign: TextAlign.center,)
        ],
      ),
    );
  }

  Widget nextButton(){
    String buttonText = "";
    return Expanded(flex: 1,
      child: BlocBuilder<ViewPagerBloc,int>(
        bloc: _pagerBloc,
        builder: (context,page){
          buttonText = "Next";
          if(page==PAGE_COUNT-1) buttonText = "Let's Go";
          return Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Row(children: [
              Text(page.toString()),
              const Spacer(),
              AppButton(size: Size(100.w,40.h),
                  onPressed:(){
                    if(page==PAGE_COUNT-1) Navigator.pushReplacementNamed(context, "/login");
                    pageViewController.nextPage(duration: const Duration(milliseconds: 800),
                        curve: Curves.easeIn);
                  }, color: Resources.mainBlue, child: Text(buttonText,
                      style:Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18.sp,
                          fontWeight: FontWeight.w500)))
            ],),
          );
        },
      ),
    );
  }
}

import 'dart:math';

import 'package:famdocs/models/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/resources.dart';

class NoFamilyScreen extends StatefulWidget {
  const NoFamilyScreen({super.key});

  @override
  State<NoFamilyScreen> createState() => _NoFamilyScreenState();
}

class _NoFamilyScreenState extends State<NoFamilyScreen> {

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20.h),
      child: Column(children: [
        appBar(),
        SizedBox(height: 40.h,),
        createJoinButtons()
      ],),);
  }

  Widget appBar(){
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Hamburger
        GestureDetector(onTap: () => Resources.dashboardToSkeletonOpenDrawerBloc.open(Random().nextInt(100000)),
          child: Container(height: 44.h,width: 44.h,
            decoration: BoxDecoration(shape: BoxShape.circle,color: Theme.of(context).hoverColor),
            child: Center(child: SvgPicture.asset("assets/hamburger.svg",
              color: Theme.of(context).secondaryHeaderColor,
            ),),),
        ),
      ],
    );
  }

  Widget createJoinButtons(){
    return Expanded(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
        createButton(),
        SizedBox(height: 10.h,),
        orDivider(),
        SizedBox(height: 10.h,),
        joinButton(),
        SizedBox(height: 10.h,),
      ],),
    );
  }

  Widget createButton(){
    return button(() => Resources.skeletonToDashboardSwitchPageBloc.switchPage(Pages.createFam));
  }

  Widget orDivider(){
    return Padding(
      padding: EdgeInsets.only(left: 20.w,right: 20.w),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(color: Theme.of(context).secondaryHeaderColor,
            height: 1.h),
          ),
        SizedBox(width: 10.w,),
        Text("OR",style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).secondaryHeaderColor
        ),),
          SizedBox(width: 10.w,),
        Expanded(
          child: Divider(color: Theme.of(context).secondaryHeaderColor,
              height: 1.h),
        )],
      ),
    );
  }

  Widget joinButton(){
    return button((){
    });
  }

  Widget button(Function() callBack){
    return SizedBox(height: MediaQuery.of(context).size.height/6,
      width: MediaQuery.of(context).size.height/6,
      child: Card(elevation: 20,
      shape: const CircleBorder(),
      child: IconButton(onPressed: callBack,
      icon: const Icon(Icons.join_full),),),
    );
  }
}

import 'package:famdocs/bloc/dashboard_blocs/expand_families_cubit.dart';
import 'package:famdocs/bloc/db_blocs/load_families_db_bloc.dart';
import 'package:famdocs/bloc/profile_screen_blocs/profile_prefs_bloc.dart';
import 'package:famdocs/common/resources.dart';
import 'package:famdocs/models/family.dart';
import 'package:famdocs/models/pages.dart';
import 'package:famdocs/models/user.dart';
import 'package:famdocs/repositories/profile_screen/profile_repository.dart';
import 'package:famdocs/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../models/drawer_option.dart';

class DashboardSkeleton extends StatefulWidget {
  const DashboardSkeleton({super.key});

  @override
  State<DashboardSkeleton> createState() => _DashboardSkeletonState();
}

class _DashboardSkeletonState extends State<DashboardSkeleton> {

  final ZoomDrawerController _drawerController = ZoomDrawerController();
  final List<DrawerOption> drawerOptionsList = List.empty(growable: true);
  late List<Widget> optionChildren;
  final LoadFamiliesBlocDB _loadFamiliesBlocDB = LoadFamiliesBlocDB([]);

  @override
  void initState() {
    initDrawerOptions();
    Resources.dashboardToSkeletonOpenDrawerBloc.stream.listen(handleDrawerCommand);
    super.initState();
  }


  void onDrawerStateChanged(){

  }

  void initDrawerOptions(){
    drawerOptionsList.add(DrawerOption(name: "Create Family",
        icon: const Icon(Icons.add_business), page: Pages.createFam));
    drawerOptionsList.add(DrawerOption(name: "Join Family",
        icon: const Icon(Icons.add_business), page: Pages.joinFam));
    drawerOptionsList.add(DrawerOption(name: "Home", icon: const Icon(Icons.home),
        page: Pages.home));
    drawerOptionsList.add(DrawerOption(name: "Notifications", icon: const Icon(Icons.notifications),
        page: Pages.notifications));
    drawerOptionsList.add(DrawerOption(name: "Profile",
        icon: const Icon(Icons.person), page: Pages.profile));
    optionChildren = drawerOptionsList.map((e) {
      return optionTile(e.name,e.icon,e.page);
    }).toList();
    optionChildren.insert(0, Container());
  }

  void handleDrawerCommand(int val){
    _loadFamiliesBlocDB.load();
    _drawerController.open!();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Scaffold(
      body: ZoomDrawer(
      controller: _drawerController,
      menuScreen: drawerMenu(),
      mainScreen: const Dashboard(),
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      openCurve: Curves.easeIn,
      closeCurve: Curves.easeOut,
      menuScreenTapClose: true,
      menuBackgroundColor: Theme.of(context).secondaryHeaderColor,
      drawerShadowsBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      ),
    ));
  }

  Widget drawerMenu(){
    return RepositoryProvider(create: (context) => ProfileRepository(),
      child: BlocProvider(create: (context) => ProfilePrefsBloc(null,RepositoryProvider.of<ProfileRepository>(context)),
        child: SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.only(top: 50.h,left: 20.w),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              nameAndAvatar(),
              SizedBox(height:30.h),
              options(),
              SizedBox(height: 10.h,),
            ],),),
        ),
      ),
    );
  }

  Widget nameAndAvatar(){
    return BlocBuilder<ProfilePrefsBloc,User?>(
      builder: (context,user){
        if(user==null) return Container();
        return Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundImage: AssetImage(Resources.avatars[user.avatarId!-1]),
              radius: 40.r,backgroundColor: Theme.of(context).hoverColor,),
            SizedBox(height: 10.h,),
            Text("Hey",
              style: Theme.of(context).textTheme.bodySmall?.
              copyWith(fontSize: 16.sp,
                fontWeight: FontWeight.w300,),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5.h,),
            Text(user.name!,style:Theme.of(context).textTheme.headlineLarge?.
            copyWith(fontSize: 35.sp,fontWeight: FontWeight.w900,)),
          ],);
      }
    );
  }

  Widget options(){
    return BlocBuilder<LoadFamiliesBlocDB,List<Family>?>(
    bloc: _loadFamiliesBlocDB,
    builder: (context,families){
      if(families!=null && families.isNotEmpty){
        optionChildren.removeAt(0);
        optionChildren.insert(0, expandableOptionTile("My families", const Icon(Icons.safety_check),
            families));
      }
      return Column(children: [
        Column(children: optionChildren),
        SizedBox(height:20.h),
        Divider(height: 2.h,color: Colors.grey,),
        SizedBox(height: 20.h,),
        optionTile("Logout", const Icon(Icons.logout),Pages.logout)
      ],);
    });
  }

  Widget optionTile(String text,Widget icon,Pages? page,[Function? customOnTap]){
    return InkWell(onTap: (){
      if(page==null) {customOnTap!(); return;}
      _drawerController.close!();
      Resources.skeletonToDashboardSwitchPageBloc.switchPage(page);
    },
      child: SizedBox(height: 60.h,child:
        Row(children: [
          icon,
          SizedBox(width: 20.w,),
          Text(text)
        ],),),
    );
  }


  //Expandable tiles ke neeche wali
  Widget familyOptionTile(Family family,Pages page){
    return InkWell(onTap: (){
      _drawerController.close!();
      Resources.skeletonToDashboardSwitchPageBloc.switchPage(page,family);
    },
      child: SizedBox(height: 60.h,child:
      Row(children: [
        SizedBox(width: 20.w,),
        Text(family.familyName!)
      ],),),
    );
  }

  Widget expandableOptionTile(String text,Widget icon,List<Family> families){
    return BlocProvider(create: (context) => ExpandFamiliesCubit(false),
      child: BlocBuilder<ExpandFamiliesCubit,bool>(
        builder: (context,state){
          return Column(
            children: [
              optionTile(text,icon, null,(){
                context.read<ExpandFamiliesCubit>().toggle();
              }),
              AnimatedContainer(duration: const Duration(milliseconds: 400),
                height: (state)?families.length*60.h:0,child:
                Column(children: families.map((e) =>
                    familyOptionTile(e,Pages.switchFam)).toList(),),),
            ],
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    _loadFamiliesBlocDB.close();
    super.dispose();
  }
}

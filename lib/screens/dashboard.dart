import 'package:famdocs/bloc/dashboard_blocs/skeleton_dashboard_bridges.dart';
import 'package:famdocs/common/resources.dart';
import 'package:famdocs/models/pages.dart';
import 'package:famdocs/screens/dashboard/family_screens/home_screen.dart';
import 'package:famdocs/screens/dashboard/bottom_sheets/join_family_sheet.dart';
import 'package:famdocs/screens/dashboard/notification_screens/notification_screen.dart';
import 'package:famdocs/screens/dashboard/profile_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'dashboard/bottom_sheets/create_family_sheet.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final PageController _pageController = PageController();
  late StateMachineController? _bottomNavController;
  SMITrigger? homeTrigger;
  SMITrigger? notificationsTrigger;
  SMITrigger? profileTrigger;
  @override
  void initState() {
    Resources.skeletonToDashboardSwitchPageBloc.stream.listen(drawerCommandHandler);
    super.initState();
  }

  void drawerCommandHandler(PageDataObject data){
    switch(data.page){
      case Pages.home:
        homeTrigger!.fire();
        _pageController.jumpToPage(0);
        break;
      case Pages.notifications:
        notificationsTrigger!.fire();
        _pageController.jumpToPage(1);
        break;
      case Pages.profile:
        profileTrigger!.fire();
        _pageController.jumpToPage(2);
        break;
      case Pages.createFam:
        showBottomSheet(const CreateFamilySheet());
        break;
      case Pages.joinFam:
        showBottomSheet(const JoinFamilySheet());
        break;
      case Pages.switchFam:
        Resources.familySwitch.changeFamily(data.family!);
        break;
      case Pages.logout:
        logout();
        break;
      default:
    }
  }


  void logout() async{
    await Resources.showAppLoader(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
    await deleteDatabase("fam.db");
    if(mounted){
      Resources.killAppLoader(context);
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route)=>true);
    }
  }


  void showBottomSheet(Widget child) async{
    await Future.wait([Future.delayed(const Duration(milliseconds: 600))]);
    if(mounted) {
      Object? result = await showModalBottomSheet(context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom:  MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(child: Wrap(children: [
              child])),
          );
        },
        sheetAnimationStyle: AnimationStyle(curve: Curves.bounceInOut,
            duration: const Duration(seconds: 1)),
        isDismissible: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.r),
            topRight: Radius.circular(40.r)
        )),
        backgroundColor: Theme
            .of(context)
            .primaryColor,);
      if(result==true) Resources.loadFamiliesBloc.loadFamilies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      bottomNavigationBar: bottomNav(),
      backgroundColor: Theme.of(context).primaryColor,
      body: pager(),
    ));
  }

  Widget bottomNav(){
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(height: 60.h,
      child: RiveAnimation.asset("assets/rive/bottom.riv",
      stateMachines: const ["sm"],
      onInit: initBottomNav,),),
    );
  }

  void initBottomNav(Artboard artboard){
    _bottomNavController = StateMachineController.fromArtboard(artboard,
        "sm",onStateChange: (machine,state){
           switch(state){
             case "Home":
               _pageController.jumpToPage(0);
               break;
             case "Notifications":
               _pageController.jumpToPage(1);
               break;
             case "Profile":
               _pageController.jumpToPage(2);
               break;
           }
        });
    homeTrigger = _bottomNavController!.getTriggerInput("Home");
    notificationsTrigger = _bottomNavController!.getTriggerInput("Notifications");
    profileTrigger = _bottomNavController!.getTriggerInput("Profile");
    artboard.addController(_bottomNavController as RiveAnimationController);
  }

  Widget fab(){
    return FloatingActionButton(onPressed: (){});
  }

  Widget pager(){
    return PageView.builder(itemBuilder: (context,index){
      switch(index){
        case 1:
          return const NotificationScreen();
        case 2:
          return const ProfileScreen();
        default:
          return const HomeScreen();
      }
    },controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
    itemCount: 3,);
  }
}

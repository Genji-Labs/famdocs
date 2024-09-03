import 'package:famdocs/bloc/notification_blocs/notification_bloc.dart';
import 'package:famdocs/common/app_button.dart';
import 'package:famdocs/common/resources.dart';
import 'package:famdocs/models/notification.dart' as Notification;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  final ScrollController _scrollController = ScrollController();
  final NotificationBloc _notificationBloc = NotificationBloc([]);
  final List<Notification.Notification> _notifications = List.empty(growable: true);
  int _offset = 0;
  final int _limit = 10;

  @override
  void initState() {
   // _scrollController.addListener(onListScrolled);
    //_notificationBloc.loadNotifications(_offset, _limit);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(backgroundColor: Theme.of(context).primaryColor,
    body: RefreshIndicator(onRefresh: refresh,
      child: Padding(padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 50.h),
      child: Column(children: [
        appBar(),
        SizedBox(height: 40.h,),
        noContent()
        //notificationsPanel()
      ],),),
    ),));
  }

  Widget noContent(){
    return Expanded(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset("assets/lottie/no_content.json"),
          SizedBox(height: 10.h,),
          Text("Looks like it's empty\nhere",style:Theme.of(context).textTheme.headlineLarge?.
          copyWith(fontSize: 27.sp,fontWeight: FontWeight.w900,color: Colors.grey,),
          textAlign: TextAlign.center,)
      ],),
    );
  }

  Widget appBar(){
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Notifications",
            style:Theme.of(context).textTheme.headlineLarge?.
            copyWith(fontSize: 20.sp,fontWeight: FontWeight.w500)),
      ],
    );
  }
  
  Widget notificationsPanel(){
    return BlocBuilder<NotificationBloc,List<Notification.Notification>>(
      bloc: _notificationBloc,
      builder: (context,state){
        _offset += _limit;
        _notifications.addAll(state);
        return Expanded(
          child: SizedBox(
            child: ListView.builder(itemBuilder: (context,index){
              return notificationTile(_notifications[index]);
            },itemCount: _notifications.length,
            cacheExtent: 100,),),
        );
      }
    );
  }

  Widget notificationTile(Notification.Notification notification) =>
   (notification.markerText==null)?contentTile(notification):notificationHeader(notification);


  Widget notificationHeader(Notification.Notification notification){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h,),
        Divider(height: 0.3.h,),
        SizedBox(height:30.h),
        Text(notification.markerText!,style:
          Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 25.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).secondaryHeaderColor
          ),textAlign: TextAlign.start,),
      ],
    );
  }

  Widget contentTile(Notification.Notification notification){
    return ListTile(leading: notification.image,
      subtitle: Text("${notification.message}  ${notification.time}",
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Theme.of(context).secondaryHeaderColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w300
      ),textAlign: TextAlign.start,),
    trailing: (notification.action==null)?null:actionButton(notification),);
  }

  Widget actionButton(Notification.Notification notification){
    return AppButton(size: Size(50.w,20.h), onPressed: (){}, color: Resources.mainBlue,
        child: Text(notification.action!.title(),
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).secondaryHeaderColor
        ),));
  }

  @override
  void dispose() {
    _notificationBloc.close();
    super.dispose();
  }

  void onListScrolled(){
    if(_scrollController.position.atEdge){
      if(_scrollController.position.pixels!=0) _notificationBloc.loadNotifications(_offset, _limit);
    }
  }


  Future<void> refresh() async{

  }
}

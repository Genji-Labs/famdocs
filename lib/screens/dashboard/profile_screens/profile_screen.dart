import 'package:famdocs/bloc/profile_screen_blocs/profile_bloc.dart';
import 'package:famdocs/common/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 50.h),
          child: Column(children: [
            appBar(),
            SizedBox(height: 20.h,),
            profileCard()
          ],),),
      ),));
  }

  Widget appBar(){
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Profile",
            style:Theme.of(context).textTheme.headlineLarge?.
            copyWith(fontSize: 20.sp,fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget profileCard(){
    return Card(color: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),child: Padding(
      padding: EdgeInsets.all(20.w),
      child: profileCardContent(),
    ),);
  }

  Widget profileCardContent(){
    return BlocProvider(create: (context) => ProfileBloc(ProfileBlocResponse(null,null)),
      child: BlocConsumer<ProfileBloc,ProfileBlocResponse>(
        listener: (context,state){
        },
        listenWhen: (prev,state) => state.exception!=null,
        builder: (context,state){
          if(state.user==null) return Container();
          return Column(children: [
            avatar(state.user!.avatarId!,state.user!.name!),
            SizedBox(height: 10.h,),
            nameAndPhone(state.user!.name!,state.user!.phone!)
          ],);
        },
      ),
    );
  }

  Widget avatar(int avatar,String name){
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(backgroundImage:
            AssetImage(Resources.avatars[avatar-1]),
              radius:50.r,
              backgroundColor: Theme.of(context).secondaryHeaderColor,),
            Positioned.fill(child:
            Align(
              alignment: Alignment.bottomRight,
              child:Icon(Icons.edit,
              color: Theme.of(context).secondaryHeaderColor,)
              ),
            )
          ],
        ),
        SizedBox(height: 10.h,),
        Text(name,style: Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 30.sp
        ),
        textAlign: TextAlign.center,)
      ],
    );
  }

  Widget nameAndPhone(String name,String phone){
    return Column(children: [
      dataField("Full Name", name,(t){}, TextEditingController(),null),
      SizedBox(height: 10.h,),
      dataField("Phone Number", phone, (t){}, TextEditingController(),phoneFieldPrefixIcon()),
    ],);
  }

  Widget dataField(String title,String content,
      Function(String) validator,TextEditingController controller,
      Widget? prefixIcon){
    controller.text = content;
    return Column(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("\t\t$title",style: Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 18.sp,
            fontWeight: FontWeight.bold),),
        SizedBox(height: 8.h,),
        TextField(maxLength: 10,
          enabled: false,
          onChanged: (text) => validator(text),
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
              filled: true,
              errorStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.redAccent,
                  fontSize: 14.sp
              ),
              prefixIcon: prefixIcon,
              errorText: "",
              fillColor: Theme.of(context).hoverColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none)),
          controller: controller,)
      ],);
  }

  Widget phoneFieldPrefixIcon(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("+91\t\t",
          style:
          Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 21.sp,
              letterSpacing: 0.8.w,
              fontWeight: FontWeight.w400
          ),),
      ],
    );
  }
}

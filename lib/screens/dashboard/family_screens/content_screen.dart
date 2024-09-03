import 'dart:io';
import 'dart:ui';
import 'package:famdocs/bloc/dashboard_blocs/load_folder_contents_bloc.dart';
import 'package:famdocs/common/resources.dart';
import 'package:famdocs/models/family.dart';
import 'package:famdocs/models/file.dart' as fileModel;
import 'package:famdocs/models/folder.dart';
import 'package:famdocs/screens/dashboard/bottom_sheets/file_options_sheet.dart';
import 'package:famdocs/screens/dashboard/dialog_screens/create_folder_dialog.dart';
import 'package:famdocs/screens/dashboard/dialog_screens/upload_file_dialog.dart';
import 'package:famdocs/services/password_entry_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../common/expandable_fab.dart';

class ContentScreen extends StatefulWidget {
  final Family family;
  final Folder folder;
  const ContentScreen({super.key,required this.family,required this.folder});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late Folder folder;
  String? directoryPath;

  @override
  Widget build(BuildContext context) {
    folder = widget.folder;
    return Expanded(
      child: BlocProvider(create: (subContext) =>
          LoadFolderContentsBloc(LoadFolderResponse("",[],folder),context),
        child: Stack(children: [
          BlocBuilder<LoadFolderContentsBloc,LoadFolderResponse>(
          builder: (context,response){
            folder = response.folder;
            directoryPath = response.name;
            return RefreshIndicator(onRefresh: () async {
              context.read<LoadFolderContentsBloc>().loadContents(folder);
            },
              child: PopScope(canPop: false,
                onPopInvokedWithResult: (val,res){
                   if(folder.name=="root") return;
                   context.read<LoadFolderContentsBloc>().loadContents(folder.parentFolder!);
                },
                child: Column(
                  children: [
                    pathBar(response.name),
                    SizedBox(height: 40.h,),
                    filesAndFolders(response.files,context),
                  ],
                ),
              ),
            );
          },),
          Builder(
            builder: (context) {
              return Positioned.fill(child:
              Align(
              alignment: Alignment.bottomRight,child: fab(context)));
            }
          )
        ],),
      ),
    );
  }

  Widget fab(BuildContext subContext){
    return ExpandableFab(distance: 50.h,
    children: [
      Container(
        child: Column(children: [
          TextButton(onPressed: () => showCreationDialog(CreationType.folder,subContext), style:
              ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(170.w,40.h)),
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).hoverColor)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Text("Add folder",style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 18.sp
            ),),
            Icon(Icons.folder,color: Theme.of(context).secondaryHeaderColor,)
              ],),),
          TextButton(onPressed: () => showCreationDialog(CreationType.file,subContext),
            style:
            ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(170.w,40.h)),
                backgroundColor: WidgetStatePropertyAll(Theme.of(context).hoverColor)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Text("Upload File",style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 18.sp
              ),),
              Icon(Icons.upload,color: Theme.of(context).secondaryHeaderColor,)
              ],),),
          TextButton(onPressed: shareJoinCode,
              style:
              ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(170.w,40.h)),
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).hoverColor)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Text("Add member",style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 18.sp
            ),),
            Icon(Icons.add,color: Theme.of(context).secondaryHeaderColor,)
          ],)),
        ],),
      )
    ]);
  }


  Widget pathBar(String name){
    return Align(alignment: Alignment.centerLeft,
      child: SingleChildScrollView(scrollDirection: Axis.horizontal,
        child: Text("Path : $name",
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
            fontSize: 21.sp
          ),),),
    );
  }

  Widget filesAndFolders(List<fileModel.FamFile> files,BuildContext subContext){
    return Expanded(
      child: Stack(
        children: [
          GridView.builder(gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
            crossAxisSpacing: 20.w,mainAxisSpacing: 20.h,),
            itemBuilder: (context,index){
              if(files[index] is Folder) {
                return folderTile(files[index] as Folder,subContext);
              } else {
                return fileTile(files[index] as fileModel.File);
              }
            },itemCount: files.length,)
        ],
      ),
    );
  }

  Widget folderTile(Folder folder,BuildContext subContext){
    return GestureDetector(onTap: () => subContext.read<LoadFolderContentsBloc>().loadContents(folder),
      child: Container(color: Theme.of(context).primaryColor,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/folder.svg",height: 50.h,width: 50.h),
            SizedBox(height: 10.h,),
            Text(folder.name!,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 23.sp
            ),textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }

  Widget fileTile(fileModel.File file){
    return GestureDetector(onTap: (){
      fileOptions(file);
    },
      child: Container(color: Theme.of(context).primaryColor,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(file.getIcon(),height: 50.h,width: 50.h,),
            SizedBox(height: 10.h,),
            Text(file.name!,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).secondaryHeaderColor,
              fontSize: 23.sp
            ),textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }

  Widget createFileDialog(){
    return UploadFileDialog(parentFolder: folder);
  }

  Widget createFolderDialog(){
    return CreateFolderDialog(parentFolder: folder,);
  }

  void fileOptions(fileModel.File file) async{
    if(await checkPasswordEntry(widget.family, context)==null) return;
    if(mounted) {
      showModalBottomSheet(context: context, builder: (context) {
        return Wrap(children: [
          FileOptionsSheet(file: file,
            directoryPath: "${widget.family.familyName}${directoryPath!}",)
        ],);
      });
    }
  }


  void showCreationDialog(CreationType type,BuildContext subContext) async{
    if(await checkPasswordEntry(widget.family, context)==null) return;
    if(mounted) {
      Object? changed = await showGeneralDialog(
          context: context, pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(filter: ImageFilter.blur(
          sigmaX: 3, sigmaY: 3,
        ),
          child: (type == CreationType.folder)
              ? createFolderDialog()
              : createFileDialog(),);
      }, transitionBuilder: (context, animation1, animation2, child) {
        return Transform.scale(
          scaleX: animation1.value,
          scaleY: animation1.value,
          child: child,
        );
      }, transitionDuration: const Duration(milliseconds: 400));
      if (changed != null) {
        BlocProvider.of<LoadFolderContentsBloc>(subContext)
          .loadContents(folder);
      }
    }
  }


  Widget joinCodeTitleText(){
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(width: 100.w,height: 6.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.r),
              color: Colors.grey),),
        SizedBox(height: 30.h,),
        Text("Joining Code",style:Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 33.sp,fontWeight: FontWeight.w900)),
      ],);
  }

  Widget joinCodeNote(){
    return Text("Share this code with your family members. The join option can be found on the left side menu panel.",
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 15.sp
      ),);
  }

  Widget joinCodeField(){
    TextEditingController _controller = TextEditingController();
    _controller.text = "FAM${widget.family.familyId}";
    return Column(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("\t\tJoin Code",style: Theme.of(context).textTheme.headlineLarge?.
        copyWith(fontSize: 18.sp,
            fontWeight: FontWeight.bold),),
        SizedBox(height: 8.h,),
        GestureDetector(onTap: (){
          Share.share("${_controller.text}\n\nUse the above join code to join ${widget.family.familyName} on FamDocs");
        },
          child: TextField(enabled: false,
            controller: _controller,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 20.sp,
              letterSpacing: MediaQuery.of(context).size.width/12,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            cursorColor: Theme.of(context).secondaryHeaderColor,
            cursorErrorColor: Theme.of(context).secondaryHeaderColor,
            decoration: InputDecoration(
                hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20.sp,
                    letterSpacing: MediaQuery.of(context).size.width/12,
                    fontWeight: FontWeight.w400
                ),
                suffixIcon: const Icon(Icons.copy),
                suffixIconColor: Theme.of(context).secondaryHeaderColor,
                filled: true,
                fillColor: Theme.of(context).hoverColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none)),),
        )
      ],);
  }

  void shareJoinCode(){
    showModalBottomSheet(context: context, builder: (context){
      return Padding(
        padding: EdgeInsets.only(bottom:  MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(child: Wrap(children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r)
            ),color: Theme.of(context).primaryColor,),
            padding: EdgeInsets.only(top: 20.h,bottom: 30.h,right: 30.w,left: 30.w),
            child: Column(children: [
              joinCodeTitleText(),
              SizedBox(height: 30.h,),
              joinCodeNote(),
              SizedBox(height: 10.h,),
              joinCodeField(),
            ],),
          )
        ],)),
      );
    });
  }
}


enum CreationType{
  file,folder
}

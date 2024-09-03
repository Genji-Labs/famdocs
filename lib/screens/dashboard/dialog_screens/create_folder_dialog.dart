
import 'package:famdocs/bloc/dialog_blocs/folder_dialog_validator_bloc.dart';
import 'package:famdocs/bloc/login_screen_blocs/phone_textfield_validator_bloc.dart';
import 'package:famdocs/common/app_button.dart';
import 'package:famdocs/repositories/folder_repository/folder_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/resources.dart';
import '../../../models/folder.dart';

class CreateFolderDialog extends StatelessWidget {
  final TextEditingController _folderNameController = TextEditingController();
  final Folder parentFolder;
  CreateFolderDialog({super.key,required this.parentFolder});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(backgroundColor: Theme.of(context).primaryColor,
      content:
    SingleChildScrollView(
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Create Folder",style: Theme.of(context).textTheme.headlineLarge?.
            copyWith(fontSize: 18.sp,
                fontWeight: FontWeight.bold),),
            SizedBox(height: 20.h,),
            RepositoryProvider(create: (context) => FolderRepository(),
              child: BlocProvider(create: (context) => FolderDialogValidatorBloc(TextFieldState(true,""))
              ,child: BlocBuilder<FolderDialogValidatorBloc,TextFieldState>(builder: (context,state){
                return textFieldAndButton(state,context);
              })),
            )
          ],),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(onPressed: (){Navigator.pop(context);}, icon:
            const Icon(Icons.cancel)),
          ),
        )
      ],),
    ),);
  }

  Widget textFieldAndButton(TextFieldState state,BuildContext context){
    return Column(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h,),
        TextField(maxLength: 10,
          onChanged: (text) => validator(context),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 20.sp,
              letterSpacing: 0.8.w,
              fontWeight: FontWeight.w400
          ),
          controller: _folderNameController,
          cursorColor: Theme.of(context).secondaryHeaderColor,
          cursorErrorColor: Theme.of(context).secondaryHeaderColor,
          decoration: InputDecoration(
              counterText: "",
              hintText: "Driving Licenses",
              hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 20.sp,
                  letterSpacing: 0.8.w,
                  fontWeight: FontWeight.w400
              ),
              filled: true,
              errorStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.redAccent,
                  fontSize: 14.sp
              ),
              errorText: state.message,
              fillColor: Theme.of(context).hoverColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none)),),
        IgnorePointer(ignoring:state.error,
          child: AppButton(size: Size(MediaQuery.of(context).size.width,60.h), onPressed: () =>
              createFolder(context),
            color: (state.error)?Colors.grey:Resources.mainBlue, child:
            Text("Create",style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18.sp,
                fontWeight: FontWeight.w500),),),
        )
      ],);
  }



  void validator(BuildContext context){
    context.read<FolderDialogValidatorBloc>().check(_folderNameController.text);
  }

  void createFolder(BuildContext context) async{
    await Resources.showAppLoader(context);
    if(!context.mounted) return;
    FolderRepository folderRepository = RepositoryProvider.of<FolderRepository>(context);
    await folderRepository.createFolder(parentFolder, _folderNameController.text);
    if(context.mounted){
      await Resources.killAppLoader(context);
      if(context.mounted) Navigator.pop(context,true);
    }
  }
}
import 'package:famdocs/bloc/dashboard_blocs/file_bloc.dart';
import 'package:famdocs/bloc/dialog_blocs/file_dialog_validator_bloc.dart';
import 'package:famdocs/models/file.dart';
import 'package:famdocs/repositories/file_repository/file_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_button.dart';
import '../../../common/resources.dart';
import '../../../models/folder.dart';
import 'package:famdocs/models/file.dart' as fileModel;
import 'dart:io' as system;

class UploadFileDialog extends StatelessWidget {
  final TextEditingController _fileNameController = TextEditingController();
  final Folder parentFolder;
  system.File? selectedFile;
  UploadFileDialog({super.key,required this.parentFolder});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(backgroundColor: Theme.of(context).primaryColor,
      content:
      SingleChildScrollView(
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 50.h,),
              Text("Upload file",style: Theme.of(context).textTheme.headlineLarge?.
              copyWith(fontSize: 18.sp,
                  fontWeight: FontWeight.bold),),
              SizedBox(height: 20.h,),
              RepositoryProvider(create: (context) => FileRepository(),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context)=>FileDialogValidatorBloc(FileFormState(true,"",selectedFile,null))),
                    BlocProvider(create: (context)=>FileBloc(fileModel.File(),context.read<FileRepository>(),context))
                  ], child: BlocBuilder<FileDialogValidatorBloc,FileFormState>(builder: (context,state){
                      return Column(
                        children: [
                          fileArea(state,context),
                          SizedBox(height: 20.h,),
                          textFieldAndButton(state,context),
                        ],
                      );
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

  Widget fileArea(FileFormState state,BuildContext context){
    if(state.preview==null) {
      return GestureDetector(onTap: () => pickFile(context),
          child: Container(margin: EdgeInsets.only(left: 20.w,right: 20.w),
            height: 200.h,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey,width: 1.w,),
            borderRadius: BorderRadius.all(Radius.circular(40.r))
          ),child:
            Column(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,children: [
              Icon(Icons.file_present_sharp,size: 50.h,color: Colors.grey,),
              SizedBox(height: 20.h,),
              Text("Attach a file",style: Theme.of(context).textTheme.headlineLarge?.
              copyWith(fontSize: 23.sp,
              color: Colors.grey),)
            ],),));
    }
    return Stack(children: [
      state.preview!,
      Positioned.fill(
        child: Align(
          alignment: Alignment.topRight,
          child: IconButton(onPressed: (){
            selectedFile = null;
            validator(context);
          }, icon:
          const Icon(Icons.cancel)),
        ),
      )
    ],);
  }

  Widget textFieldAndButton(FileFormState state,BuildContext context){
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
          controller: _fileNameController,
          cursorColor: Theme.of(context).secondaryHeaderColor,
          cursorErrorColor: Theme.of(context).secondaryHeaderColor,
          decoration: InputDecoration(
              counterText: "",
              hintText: "My Adhaar",
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
              uploadFile(context),
            color: (state.error)?Colors.grey:Resources.mainBlue, child:
            Text("Create",style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18.sp,
                fontWeight: FontWeight.w500),),),
        )
      ],);
  }


  void validator(BuildContext context){
    context.read<FileDialogValidatorBloc>().validate(_fileNameController.text, selectedFile);
  }

  void uploadFile(BuildContext context) async{
    fileModel.File famFile = fileModel.File();
    famFile.parentFolder = parentFolder;
    famFile.systemFile = selectedFile;
    BlocProvider.of<FileBloc>(context).upload(famFile, parentFolder, _fileNameController.text);
    if(context.mounted) {
      Future.delayed(Duration(seconds: 3),(){
      Navigator.pop(context,true);
    });
    }
  }

  void pickFile(BuildContext context) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if(result==null) return;
    List<system.File> files = result.paths.map((path) => system.File(path!)).toList();
    if(files.isNotEmpty) selectedFile = files[0];
    if(context.mounted) validator(context);
  }
}

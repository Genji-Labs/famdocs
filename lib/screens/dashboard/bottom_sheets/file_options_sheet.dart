import 'package:famdocs/bloc/dashboard_blocs/file_bloc.dart';
import 'package:famdocs/common/back_arrow.dart';
import 'package:famdocs/common/resources.dart';
import 'package:famdocs/models/file.dart';
import 'package:famdocs/repositories/file_repository/file_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FileOptionsSheet extends StatefulWidget {
  final File file;
  final String directoryPath;
  const FileOptionsSheet({super.key,required this.file,required this.directoryPath});

  @override
  State<FileOptionsSheet> createState() => _FileOptionsSheetState();
}

class _FileOptionsSheetState extends State<FileOptionsSheet> {
  List<FileOption> options = List.empty(growable: true);

  @override
  void initState() {
    initOptions();
    super.initState();
  }

  void initOptions(){
    //options.add(FileOption("Preview",const Icon(Icons.preview),preview));
    options.add(FileOption("Download",Icons.download, download));
  }

  void preview(){

  }

  void download(FileBloc fileBloc) async{
    fileBloc.download(widget.file,widget.directoryPath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.only(topRight: Radius.circular(20.r),
          topLeft: Radius.circular(20.r))),
      padding: EdgeInsets.only(top: 20.h,bottom: 20.h,),
      child: RepositoryProvider(create: (context) => FileRepository(),
        child: BlocProvider(create: (context) => FileBloc(widget.file,context.read<FileRepository>(),context),
          child: BlocConsumer<FileBloc,File>(
            listener: (context,file){
              if(file.systemFile!=null) Navigator.pop(context);
            },
            builder: (context,file){
              return Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 100.w,height: 6.h,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.r),
                        color: Colors.grey),),
                  SizedBox(height: 10.h,),
                  Text("Download ${file.name!}",style: Theme.of(context).textTheme.headlineLarge?.
                  copyWith(fontSize: 18.sp,
                      fontWeight: FontWeight.bold),),
                  SizedBox(height: 5.h,),
                  Text("File will be saved to Downloads/FamDocs/${widget.directoryPath}",
                    style: Theme.of(context).textTheme.headlineLarge?.
                  copyWith(fontSize: 14.sp,
                      fontWeight: FontWeight.bold),),
                  SizedBox(height: 20.h,),
                  Column(
                    children: options.map((option) =>
                        ListTile(leading:Icon(option.icon,color: Theme.of(context).secondaryHeaderColor,),
                          title: Text(option.text,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).secondaryHeaderColor
                          ),),onTap: () =>
                              option.callback(context.read<FileBloc>()),)).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FileOption{
  final String text;
  final IconData icon;
  final Function(FileBloc bloc) callback;
  FileOption(this.text,this.icon,this.callback);
}

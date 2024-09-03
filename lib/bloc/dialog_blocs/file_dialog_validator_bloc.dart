import 'package:file_previewer/file_previewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
class FileFormState{
  final File? file;
  final Widget? preview;
  final bool error;
  final String message;
  bool? showLoader;
  FileFormState(this.error,this.message,this.file,this.preview);
}
class FileDialogValidatorBloc extends Cubit<FileFormState>{
  FileDialogValidatorBloc(super.initialState);

  void validate(String name,File? selectedFile) async{
    Widget? preview;
    if(selectedFile!=null) preview = await FilePreview.getThumbnail(selectedFile.path);
    if(name.trim().isEmpty){
      emit(FileFormState(true, "file name required",selectedFile,preview));
      return;
    }
    if(selectedFile==null){
     emit(FileFormState(true, "",selectedFile,preview));
     return;
    }
    emit(FileFormState(false, "",selectedFile,preview));
  }
}
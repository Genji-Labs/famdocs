import 'dart:convert';

import 'package:famdocs/common/resources.dart';
import 'package:famdocs/models/file.dart';
import 'package:famdocs/models/folder.dart';
import 'package:famdocs/repositories/folder_repository/folder_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderContents{
  List<File>? files;
  List<Folder>? folders;
  FolderContents(this.folders,this.files);
  FolderContents.fromJson(String json,Folder parentFolder){
    Map<String,dynamic> decoded = jsonDecode(json);
    List? decodedFolders = decoded["folders"];
    List? decodedFiles = decoded["files"];
    late Folder folder;
    late File file;
    if(decodedFolders!=null) {
      folders = decodedFolders.map((e){
      folder = Folder.fromJson(jsonEncode(e));
      folder.parentFolder = parentFolder;
      return folder;
    }).toList();
    }
    if(decodedFiles!=null) {
      files = decodedFiles.map((e){
      file = File.fromJson(jsonEncode(e));
      file.parentFolder = parentFolder;
      return file;
    }).toList();
    }
  }
}

class LoadFolderResponse{
  final String name;
  final List<FamFile> files;
  final Folder folder;
  LoadFolderResponse(this.name,this.files,this.folder);
}

class LoadFolderContentsBloc extends Cubit<LoadFolderResponse>{
  final BuildContext context;
  LoadFolderContentsBloc(super.initialState,this.context){
    loadContents(super.state.folder);
  }

  void loadContents(Folder folder) async{
    await Resources.showAppLoader(context);
    LoadFolderResponse response = LoadFolderResponse("", [], folder);
    try{
      FolderRepository folderRepository = FolderRepository();
      FolderContents contents = await folderRepository.getFolderContents(folder);
      List<FamFile> files = List.empty(growable: true);
      if(contents.folders!=null) files.addAll(contents.folders!);
      if(contents.files!=null) files.addAll(contents.files!);
      String name = (folder.name=="root")?"/":traverseParentFolders(folder);
      response = LoadFolderResponse(name, files, folder);
    }catch(e){
      if(kDebugMode) print(e);
    }finally{
     if(context.mounted) Resources.killAppLoader(context);
     emit(response);
    }
  }

  String traverseParentFolders(Folder? folder){
    String name = "";
    while(folder!=null){
      if(folder.name!="root") name = "/${folder.name}$name";
      folder = folder.parentFolder;
    }
    return name;
  }
}
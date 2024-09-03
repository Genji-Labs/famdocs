import 'dart:io';

import 'package:famdocs/database/password_database_helper.dart';
import 'package:famdocs/exceptions/arbitrary_exception.dart';
import 'package:famdocs/models/file.dart';
import 'package:famdocs/models/folder.dart';
import 'package:famdocs/repositories/file_repository/file_repository.dart';
import 'package:famdocs/services/encryption/encrypter_decrypter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' as system;

import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/resources.dart';

class FileBloc extends Cubit<File>{
  final FileRepository fileRepository;
  final BuildContext context;
  FileBloc(super.initialState,this.fileRepository,this.context);

  void download(File file,String savePath) async{
    await Resources.showAppLoader(context);
    try{
      BigInt familyId = file.parentFolder!.familyId!;
      PasswordDatabaseHelper passwordDatabaseHelper = PasswordDatabaseHelper(1);
      String? password = await passwordDatabaseHelper.getPassword(familyId);
      if(password==null) throw "family password not found";
      while(password!.length<65) {
        password += password;
      }
      Uint8List encryptedBytes = await fileRepository.downloadFile(file);
      system.File encryptedFile = system.File("${(await getTemporaryDirectory()).path}/temp_file");
      encryptedFile.writeAsBytesSync(encryptedBytes);
      await requestPermissions(savePath);
      file.systemFile = await decryptFile(password,
          encryptedFile,savePath,file.name!);
      emit(file);
    }on ArbitraryException catch(e){
      if(kDebugMode) print(e.message);
      emit(file);
    }catch(e){
      emit(file);
    }finally{
      if(context.mounted) await Resources.killAppLoader(context);
    }
  }

  void upload(File file,Folder parentFolder,String customFileName) async{
    await Resources.showAppLoader(context);
    try{
      BigInt familyId = file.parentFolder!.familyId!;
      PasswordDatabaseHelper passwordDatabaseHelper = PasswordDatabaseHelper(1);
      String? password = await passwordDatabaseHelper.getPassword(familyId);
      if(password==null) throw "family password not found";
      while(password!.length<65) {
        password += password;
      }
      String? extension = await getExtension(file.systemFile!.path);
      file.systemFile = await
      encryptFile(password,
          file.systemFile!);
      await fileRepository.uploadFile(parentFolder,file.systemFile!.path,customFileName,extension);
      emit(file);
    }on ArbitraryException catch(e){
      if(kDebugMode) print(e.message);
      emit(file);
    }catch(e){
      if(kDebugMode) print(e);
      emit(file);
    }finally{
      if(context.mounted) await Resources.killAppLoader(context);
    }
  }

  Future<String?> getExtension(String path) async{
    var data = await system.File(path).readAsBytes();
    var mime = lookupMimeType('',headerBytes: data);
    if(mime==null) return null;
    String ext = extensionFromMime(mime);
    if(ext=="jpe") return "jpeg";
    return ext;
  }

  Future<void> requestPermissions(String savePath) async{
    PermissionStatus status = await Permission.storage.status;
    if(status.isPermanentlyDenied) {
      throw ArbitraryException("Permissions permanently denied",
          "");
    }
    status = await Permission.manageExternalStorage.request();
    if(!status.isGranted){
      throw ArbitraryException("Denied", "");
    }
    Directory directory;
    if(Platform.isAndroid){
      directory = Directory("${Resources.downloadPath}/$savePath");
    }else{
      directory = await getApplicationDocumentsDirectory();
    }
    directory.createSync(recursive: true);
  }

  void delete(File file) async{

  }
}
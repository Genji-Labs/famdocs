import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';

import '../../common/resources.dart';

Future<File> encryptFile(String password, File file) async {
  if(kDebugMode) print("Encrypting with $password");
  Uint8List key = Uint8List.fromList(password.substring(0, 32).codeUnits);
  Uint8List iv = Uint8List.fromList(password.substring(0, 16).codeUnits);
  if (iv.length != 16 || key.length != 32) throw ("Iv len: ${iv.length}, key Len: ${key.length}");
  final cbc = CBCBlockCipher(AESEngine());
  final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cbc);
  paddedCipher.init(true, PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
    ParametersWithIV(KeyParameter(key), iv),
    null,
  ));
  final fileBytes = file.readAsBytesSync();
  final encryptedBytes = paddedCipher.process(fileBytes);
  File encryptedFile = File("${(await getTemporaryDirectory()).path}/temp_file");
  encryptedFile.createSync();
  encryptedFile.writeAsBytesSync(encryptedBytes);
  return encryptedFile;
}

Future<File> decryptFile(String password, File file,String savePath,String fileName) async{
  if(kDebugMode) print("Decrypting with $password");
  Uint8List key = Uint8List.fromList(password.substring(0, 32).codeUnits);
  Uint8List iv = Uint8List.fromList(password.substring(0, 16).codeUnits);
  if (iv.length != 16 || key.length != 32) throw ("Iv len: ${iv.length}, key Len: ${key.length}");
  final cbc = CBCBlockCipher(AESEngine());
  final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cbc);
  paddedCipher.init(false, PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
    ParametersWithIV(KeyParameter(key), iv),
    null,
  ));
  final encryptedFileBytes = file.readAsBytesSync();
  final decryptedBytes = paddedCipher.process(encryptedFileBytes);
  File decryptedFile = File("${Resources.downloadPath}/$savePath/$fileName");
  decryptedFile.createSync();
  decryptedFile.writeAsBytesSync(decryptedBytes);
  return decryptedFile;
}

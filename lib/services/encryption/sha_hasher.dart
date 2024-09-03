import 'dart:convert';

import 'package:pointycastle/digests/sha256.dart';

import 'bin2hex.dart';

String hashIt(String text){
  return bin2hex(SHA256Digest().process(utf8.encode(text)));
}
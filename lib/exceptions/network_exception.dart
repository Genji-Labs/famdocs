import 'package:famdocs/exceptions/custom_exception.dart';

class NetworkException extends CustomException{
  NetworkException(super.message, super.flutterError);
}
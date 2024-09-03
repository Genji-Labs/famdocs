import 'package:famdocs/exceptions/custom_exception.dart';

class BlocResponse{
  final CustomException? exception;
  BlocResponse(this.exception);
}
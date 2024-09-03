import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../database/password_database_helper.dart';
import '../models/family.dart';
import '../screens/dashboard/bottom_sheets/family_password_sheet.dart';

Future<Object?> checkPasswordEntry(Family family,BuildContext context) async{
  PasswordDatabaseHelper passwordDatabaseHelper = PasswordDatabaseHelper(1);
  bool entryExists = await passwordDatabaseHelper.checkPasswordEntry(family.familyId!);
  if(entryExists) return true;
  if(context.mounted) return requestFamilyPassword(family,context);
  return null;
}

Future<Object?> requestFamilyPassword(Family family,BuildContext context) async{
  return await showModalBottomSheet(context: context,
    enableDrag: false,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom:  MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(child: Wrap(children: [
          FamilyPasswordSheet(family: family)
        ])),
      );
    },
    sheetAnimationStyle: AnimationStyle(curve: Curves.bounceInOut,
        duration: const Duration(seconds: 1)),
    isDismissible: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40.r),
        topRight: Radius.circular(40.r)
    )),
    backgroundColor: Theme
        .of(context)
        .primaryColor,);
}
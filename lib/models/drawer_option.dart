import 'package:famdocs/models/pages.dart';
import 'package:flutter/material.dart';

class DrawerOption{
  final String name;
  final Widget icon;
  final Pages page;
  DrawerOption({required this.name,required this.icon,required this.page});
}
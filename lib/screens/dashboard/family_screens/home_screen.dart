import 'package:famdocs/bloc/dashboard_blocs/load_families_bloc.dart';
import 'package:famdocs/common/resources.dart';
import 'package:famdocs/screens/dashboard/family_screens/family_screen.dart';
import 'package:famdocs/screens/dashboard/family_screens/no_family_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/family.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(backgroundColor: Theme.of(context).primaryColor,
    body: BlocProvider(create: (context) => Resources.loadFamiliesBloc  = LoadFamiliesBloc([],context),
    child: BlocBuilder<LoadFamiliesBloc,List<Family>>(builder: (context,families){
      if(families.isEmpty){
        return const NoFamilyScreen();
      }else{
        Resources.families = families;
        return const FamilyScreen();
      }
    },),)));
  }
}

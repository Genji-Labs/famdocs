import 'package:famdocs/bloc/theme_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'common/resources.dart';
import 'services/custom_router.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FamApp());
}

class FamApp extends StatefulWidget {
  const FamApp({super.key});

  @override
  State<FamApp> createState() => _FamAppState();
}

class _FamAppState extends State<FamApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
    designSize: const Size(475,912),
      child: BlocBuilder<ThemeBloc,ThemeMode>(
        bloc: Resources.themeBloc,
        builder: (context,themeMode){
          return MaterialApp(
            themeMode: themeMode,
            theme: Resources.lightTheme,
            darkTheme: Resources.darkTheme,
            initialRoute: "/splash",
            onGenerateRoute: getRoute,);
        },
      ),
    );
  }
}

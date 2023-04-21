import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart/bloc/loading/loading_bloc.dart';
import 'package:smart/bloc/tab/tab_service_bloc.dart';
import 'package:smart/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocumentDirectory = await getApplicationDocumentsDirectory();
  var path = appDocumentDirectory.path;

  runApp(MultiBlocProvider(providers: [
    BlocProvider<TabServiceBloc>(
        create: (BuildContext context) => TabServiceBloc()),
    BlocProvider<LoadingBloc>(create: (BuildContext context) => LoadingBloc()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
      title: "SBB DEMO",
      home: AnimatedSplashScreen(
        backgroundColor: Colors.white,
        splash: "assets/companyLogo.png",
        nextScreen: HomeScreen(),
        centered: true,
        splashIconSize: 100,
      ),
    );
  }
}

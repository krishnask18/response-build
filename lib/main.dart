import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'HomeScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'createScreen.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Directory, File, Platform;
import 'package:window_manager/window_manager.dart';
import 'package:path/path.dart';
import 'jsonHandler.dart';
import 'package:permission_handler/permission_handler.dart';

String libpath = '';
bool firstModalRoute(Route<dynamic> route) => route.isFirst;


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isWindows || Platform.isMacOS || Platform.isLinux){
    libpath = '${(dirname(Platform.script.path).replaceAll('/', '\\')).replaceFirst('\\', '')}\\lib';
    WindowManager.instance.setFullScreen(false);
    WindowManager.instance.setResizable(false);
    WindowManager.instance.setTitle("Response");
  }
  if(Platform.isAndroid){
    libpath = '/storage/emulated/0/response';
    await createFolder();
  }
  SetupJSON();
  runApp(const Response());
}

class MyAppdata{
  static const title = 'Response';
  static const titlestyle = TextStyle(color: Color.fromRGBO(180, 180, 180, 1.0),
      fontFamily: 'yourFont',
      fontSize: 27,
      fontWeight: FontWeight.w400);
  static const funcstyle = TextStyle(
      color: Color.fromRGBO(180, 180, 180, 1.0),
      fontFamily: 'yourFont',
      fontSize: 23,
      fontWeight: FontWeight.w400);
  static const menustyle = TextStyle(color: Color.fromRGBO(180, 180, 180, 1.0),
      fontFamily: 'yourFont',
      fontSize: 27,
      fontWeight: FontWeight.w200);
  static const styl = TextStyle(
      color: Color.fromRGBO(180, 180, 180, 1.0),
      fontFamily: 'yourFont',
      fontSize: 20,
      fontWeight: FontWeight.w400);
  static const substyl = TextStyle(
      color: Color.fromRGBO(150, 150, 150, 1.0),
      fontFamily: 'yourFont',
      fontSize: 15,
      fontWeight: FontWeight.w400);
  static const big_styl = TextStyle(
      color: Color.fromRGBO(180, 180, 180, 1.0),
      fontFamily: 'yourFont',
      fontSize: 24,
      fontWeight: FontWeight.w300);
  static const bold_styl = TextStyle(
      color: Color.fromRGBO(180, 180, 180, 1.0),
      fontFamily: 'yourFont',
      fontSize: 24,
      fontWeight: FontWeight.w400);

  static const bgcolor = Color.fromRGBO(7, 28, 40, 1.0);
  static const barcolor = Color.fromRGBO(15, 42, 60, 1.0);
  static const keybgcolor = Color.fromRGBO(8, 31, 45, 1.0);
  // static const barcolor = Color.fromRGBO(0, 15, 21, 1.0);
  static const menucolor = Color.fromRGBO(0, 12, 20, 1.0);
  static const buttoncolor = Color.fromRGBO(3, 18, 30, 1.0);

}


class Response extends StatelessWidget {
  const Response({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: MyAppdata.title,
        home:
            // HomeScreen(),
        AnimatedSplashScreen(
          duration: 500,
          splash: const Center(child: Text('Response', style: MyAppdata.titlestyle)),
          nextScreen: const HomeScreen(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: MyAppdata.bgcolor,
        ),
    );
  }
}


Future<bool> createFolder() async {
  if (await Permission.storage.request().isGranted){
    await Directory(libpath).create();
    await Directory('$libpath/signals').create();
  }
  else {
    createFolder();
  }
  return true;
}


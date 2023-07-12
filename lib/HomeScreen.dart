import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'jsonHandler.dart';
import 'main.dart';
import 'SignalClass.dart';
import 'createScreen.dart';
import 'drawer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home {

  static var appbar = AppBar(
    bottom: PreferredSize(preferredSize: const Size.fromHeight(60), child: Column(
      children: [
        Row(
          children: const [
            SizedBox(width: 10,),
            Text('Created Signals', style: MyAppdata.funcstyle,),
          ],
        ),
        const SizedBox(height: 15,),
      ],
    ),),
    backgroundColor: MyAppdata.barcolor,
    systemOverlayStyle : const SystemUiOverlayStyle(statusBarColor: MyAppdata.barcolor, systemNavigationBarColor: MyAppdata.keybgcolor),
    title: Row(
      children: const [
        Text('Response', style: MyAppdata.titlestyle,),
        Spacer(),
      ],
    ),

  );
  static var col;
  static var addrow;
  static var bodyCol;
  static List SigObjList = [];
}


class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

    @override
    State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{
  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var ls = <Widget>[];
    for(int i = 0; i < Home.SigObjList.length; i++){
      ls.add(Home.SigObjList[i].SigRow(context));
    }
    if(ls.isEmpty){
      ls.add(InkWell(
        onTap: ()=>{
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => const CreateScreen()))
        },
        splashFactory: NoSplash.splashFactory,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 154,
          child: const Column(
            children: [
              SizedBox(height: 250),
              Text('You haven\'t created signals yet\n                  Tap to create', style: MyAppdata.styl,),
              SizedBox(height: 265,),
              // Row(
              //   children: [
              //     SizedBox(width: 280,),
              //     SizedBox(
              //       height: 70,
              //       width: 70,
              //       child: FittedBox(
              //         child: FloatingActionButton(onPressed: ()=>{},
              //           backgroundColor: MyAppdata.barcolor,
              //           hoverColor: MyAppdata.keybgcolor,
              //           child: const Icon(Icons.add, size:30,
              //             color: Color.fromRGBO(180, 180, 180, 1),)),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      )
      );
    }
    Home.addrow = ()=>{
      setState((){
        for(int i = 0; i < Home.SigObjList.length; i++){
          ls.add(Home.SigObjList[i].SigRow(context));
        }
        if(ls.isEmpty){
          ls.add(InkWell(
            onTap: ()=>{
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) => const CreateScreen()))
            },
            splashFactory: NoSplash.splashFactory,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 154,
              child: Column(
                children: const [
                  SizedBox(height: 250),
                  Text('You haven\'t created signals yet\n                  Tap to create', style: MyAppdata.styl,),
                  SizedBox(height: 265,),
                  // Row(
                  //   children: [
                  //     SizedBox(width: 280,),
                  //     SizedBox(
                  //       height: 70,
                  //       width: 70,
                  //       child: FittedBox(
                  //         child: FloatingActionButton(onPressed: ()=>{},
                  //             backgroundColor: MyAppdata.barcolor,
                  //             hoverColor: MyAppdata.keybgcolor,
                  //             child: const Icon(Icons.add, size:30,
                  //               color: Color.fromRGBO(180, 180, 180, 1),)),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          )
          );
        }
        }),
      };
    Home.col = SingleChildScrollView(
      child: Column(
        children: ls,
      ),
    );
    Home.bodyCol = Home.col;
    return Scaffold(
        drawer: const NavDrawer(),
        backgroundColor: MyAppdata.bgcolor,
        body: Home.bodyCol,
        floatingActionButton:
        SizedBox(
          height: 65, width: 65, child: FittedBox(
            child: FloatingActionButton(onPressed: ()=>{
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) => CreateScreen()))
            },
                backgroundColor: MyAppdata.barcolor,
                hoverColor: MyAppdata.keybgcolor,
                child: const Icon(Icons.add, size:30,
                color: Color.fromRGBO(180, 180, 180, 1),)),
          ),
        ),
        appBar: Home.appbar);
  }
}
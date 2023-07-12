import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'createScreen.dart';

import 'HomeScreen.dart';
import 'SignalClass.dart';
import 'main.dart';

class jsonData{
  static var SigList = [];
  static var SigData;
  static File SigFile = File('$libpath/SignalsList.json');
}

SetupJSON()async{
  if(File('$libpath/SignalsList.json').existsSync()){
    try{
      jsonData.SigFile = File('$libpath/SignalsList.json');
    } catch(e) {
      await File('$libpath/SignalsList.json').delete();
      await CreateEmptySigList();
    }
  } else{
    await CreateEmptySigList();
  }
  String fstr = await jsonData.SigFile.readAsString();
  print('$fstr is only data');
  jsonData.SigData = jsonDecode(fstr);
  jsonData.SigList = jsonData.SigData["List"];
  await checkJSON();
}

Future<bool> CreateEmptySigList() async {
  await File('$libpath/SignalsList.json').create();
  jsonData.SigData = {"List": []};
  jsonData.SigFile = File('$libpath/SignalsList.json');
  await jsonData.SigFile.writeAsString(json.encode(jsonData.SigData).toString());
  return true;
}

Future<bool> SigLoad()async {
    String fstr = await jsonData.SigFile.readAsString();
    jsonData.SigData = jsonDecode(fstr);
    jsonData.SigList = jsonData.SigData["List"];
    return true;
}

Future<bool> SigFileUpdator() async {
  jsonData.SigData = {"List": jsonData.SigList};
  jsonData.SigFile.writeAsStringSync('');
  await jsonData.SigFile.writeAsString(json.encode(jsonData.SigData).toString());
  return true;
}

Future<bool> checkJSON() async {
  Home.SigObjList = [];
  for(int i = 0; i < jsonData.SigList.length; i++){
      String signame = jsonData.SigList[i];
      if(File('$libpath/signals/$signame.json').existsSync()){
        var f = File('$libpath/signals/$signame.json');
        try{
        var fstr = await f.readAsString();
        var data = jsonDecode(fstr.toString());
        Home.SigObjList.add(Signal(signame));
        if ((data["name"] != null) &&
            (data["fs"] != null)) {
        } else {
          jsonData.SigList.remove(signame);
          f.deleteSync();
          i--;
        }
      } catch(e){
          jsonData.SigList.remove(signame);
          f.deleteSync();
          i--;
        }
    } else {
        jsonData.SigList.remove(signame);
        i--;
      }
  }
  SigFileUpdator();
  return true;
}
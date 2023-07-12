import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'SignalClass.dart';
import 'jsonHandler.dart';
import 'package:scidart/numdart.dart' as scn;
import 'HomeScreen.dart';
import 'createScreen.dart';
import 'main.dart';
import 'package:function_tree/function_tree.dart';
import 'package:scidart/scidart.dart' as scidart;

List<double> listspace(double start, double stop, int delta) {
  if(delta == 0){
    return [];
  }
  double incrementCount = (stop - start) / delta;
  List<double> base = [start];
  for(int i = 0; i < delta-1; i++){
    base.add(base.last+incrementCount);
  }
  return base;
}

Future<bool> jsonCreate1(BuildContext context, String name, double fs, List spans)async{
  // showDialog(
  //   barrierDismissible: false,
  //   context: context,
  //   builder: (BuildContext context) {
  //     return Create.creatingDialog;
  //   });
  // await Future.delayed(Duration(seconds: 3));
  var ls = jsonData.SigList;
  for(int i = 0; i < ls.length; i++){
    if(ls[i] == name){
      signalExist(context, name);
      return true;
    }
  }
  jsonData.SigData["List"].add(name);
  SigFileUpdator();
  var t = [], mag = [], phase = [], real = [], imag = [], f, xn = [], xn_ = [], _t = [];
  scn.ArrayComplex  xk = scn.ArrayComplex([]);
  List<scn.Complex>xnf = [];
  List<scn.Complex> xnf_ = [];
  for(int i = 0; i < spans.length; i++){
      xnf_ = [];
      xn_ = [];
      _t = [];
      if(i == 0){
        int dist = ((spans[i][0].toString().interpret())*fs).round();
        _t.addAll(listspace(0, spans[i][0].toString().interpret() as double, dist));
        t.addAll(_t);
        for(int j = 0; j < _t.length; j++){
          xnf_.add(scn.Complex(real : 0, imaginary: 0));
          xn_.add(0);
        }
        _t = [];
      }
      _t.addAll(listspace(spans[i][0].toString().interpret() as double, spans[i][1].toString().interpret() as double, spans[i][3]));
      t.addAll(_t);
      for(int j = 0; j < _t.length; j++){
        xnf_.add(scn.Complex(real : (spans[i][2].replaceAll('t', '${_t[j]}').toString()).interpret() as double, imaginary: 0));
        xn_.add(spans[i][2].replaceAll('t', '${_t[j]}').toString().interpret() as double);
      }
      _t = [];
      if((i != spans.length -1)){
        int dist = ((spans[i+1][0].toString().interpret()- spans[i][1].toString().interpret())*fs).round();
        _t.addAll(listspace(spans[i][1].toString().interpret() as double, spans[i+1][0].toString().interpret() as double, dist));
        t.addAll(_t);
        for(int j = 0; j < _t.length; j++){
          xnf_.add(scn.Complex(real : 0, imaginary: 0));
          xn_.add(0);
        }
        _t = [];
      }
      xnf.addAll(xnf_);
      xn.addAll(xn_);
  }
  // print('xn');
  xk = scidart.fft(scn.ArrayComplex(xnf));
  // print('dft');
  f = listspace(0, fs, xk.length);
  for(int i = 0; i<xk.length; i++){
    mag.add(scn.complexAbs(xk[i]));
    real.add(xk[i].real);
    imag.add(xk[i].imaginary);
    phase.add(scn.atan2Fast(real[i], imag[i]));
  }
  // print('dft+child');

  var dict = {
    "name" : name,
    "fs" : fs,
    "timespans" : spans,
    "t":t.join(' '),
    "f":f.join(' '),
    "xn":xn.join(' '),
    "real":real.join(' '),
    "imag":imag.join(' '),
    "abs":mag.join(' '),
    "phase":phase.join(' '),
  };
  // print('dict');
  File('$libpath/signals/$name.json').create();
  var file = File('$libpath/signals/$name.json');
  await file.writeAsString(json.encode(dict).toString());
  Home.SigObjList.add(Signal(name));
  Create.backtoHome(context);
  // Navigator.of(context).pop();
  Home.addrow();
  return true;
}

Future signalExist(BuildContext context, String name) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text('$name Signal already exists. Enter other name', style: const TextStyle(
                color: Color.fromRGBO(150, 150, 150, 1),
                fontFamily: 'yourFont',
                fontSize: 24,
                fontWeight: FontWeight.w500),),
          ),
          backgroundColor: MyAppdata.bgcolor,
        );
      });
}
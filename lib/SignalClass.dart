import 'dart:convert';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:function_tree/function_tree.dart';
import 'jsonHandler.dart';
import 'main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'HomeScreen.dart';


class Signal {
  var SigFile;
  var tspans;
  var name;
  var fs;
  var t = [];
  var n = [];
  var f = [];
  var xn = [];
  var abs = [];
  var phase = [];
  var real = [];
  String spanstr = '';
  var imag = [];
  Signal(String nam) {
    name = nam;
    SigFile = File('$libpath/signals/$name.json');
    String filestr = SigFile.readAsStringSync();
    var data = json.decode(filestr);
    fs = data['fs'];
    tspans = data['timespans'];
    List xnstr = data['xn'].split(' ');
    List tstr = data['t'].split(' ');
    List fstr = data['f'].split(' ');
    List absstr = data['abs'].split(' ');
    List phasestr = data['phase'].split(' ');
    List realstr = data['real'].split(' ');
    List imagstr = data['imag'].split(' ');
    bool grid = false;
    for (int i = 0; i < xnstr.length; i++) {
      n.add(i+0.0);
      xn.add(xnstr[i].toString().interpret());
      t.add(tstr[i].toString().interpret());
      f.add(fstr[i].toString().interpret());
      abs.add(absstr[i].toString().interpret());
      phase.add(phasestr[i].toString().interpret());
      real.add(realstr[i].toString().interpret());
      imag.add(imagstr[i].toString().interpret());
    }
    for(int i = 0; i < tspans.length; i++){
      spanstr = '$spanstr${tspans[i][2]}';
      if(i != tspans.length -1){
        spanstr = '$spanstr,  ';
      }
    }
    print('DONE1');
  }
  Widget SigRow(BuildContext context) {
    return Slidable(
      direction: Axis.horizontal,
      startActionPane: ActionPane(
        extentRatio: 0.2,
        motion: InkWell(
            onTap: () async {
              jsonData.SigList.remove(name);
              await SigFileUpdator();
              await checkJSON();
              Home.addrow();
              await File('$libpath/signals/$name.json').delete();
            },
            splashColor: MyAppdata.bgcolor,
            splashFactory: NoSplash.splashFactory,
            child: Container(
                width: 80,
                color: MyAppdata.barcolor,
                child: const Icon(Icons.delete_rounded,
                    size: 30, color: Color.fromRGBO(180, 180, 180, 1)))),
        children: const [],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => chartState(this)));
        },
        splashFactory: InkSparkle.splashFactory,
        hoverColor: const Color.fromRGBO(0, 24, 32, 1.0),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const SizedBox(
                    width: 60,
                    child: Icon(Icons.equalizer,
                        size: 30, color: Color.fromRGBO(180, 180, 180, 1))),
                // const SizedBox(width: 10,),
                SizedBox(
                  width: 310,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                        width: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 240,
                              child: Text(
                                name,
                                style: MyAppdata.styl,
                                overflow: TextOverflow.ellipsis,
                              )),
                          SizedBox(
                              width: 65,
                              child: Text(
                                'fs : $fs',
                                style: MyAppdata.substyl,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 7.5,
                        width: 0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 290,
                            child: Text(
                              spanstr,
                              style: MyAppdata.substyl,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2.5,
                        width: 0,
                      ),
                    ],
                  ),
                ),
                // InkWell(
                //     onTap: () async {
                //       jsonData.SigList.remove(signame);
                //       Home.addrow();
                //       await File('$libpath/signals/$signame.json').delete();
                //       await SigFileUpdator();
                //       await checkJSON();
                //     },
                //     splashColor: MyAppdata.bgcolor,
                //     splashFactory: NoSplash.splashFactory,
                //     child: const Icon(Icons.delete_rounded,size: 30, color: Color.fromRGBO(180, 180, 180, 1))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class chartState extends StatefulWidget{
  late Signal sig;
  chartState(Signal s){
    this.sig = s;
  }
  @override
  State<StatefulWidget> createState() => chart(sig);
}

class chart extends State<chartState>{

  late Signal sig;
  var spotx, spoty;
  bool grid = false;
  double gridwidth = 0;
  String xdropdownValue = 't';
  String ydropdownValue = 'xn';
  List<ChartData> spotlist = [];
  chart(Signal s){
    this.sig = s;
    spotx = s.t;
    spoty = s.xn;
    for(int i = 0; i < spotx.length; i++){
    spotlist.add(ChartData(spotx[i], spoty[i]));
    }
  }

  setspots(){
    if(xdropdownValue == 'n') spotx = sig.n;
    else if(xdropdownValue == 't') spotx = sig.t;
    else spotx = sig.f;
    if(ydropdownValue == 'abs') spoty = sig.abs;
    else if(ydropdownValue == 'xn') spoty = sig.xn;
    else if(ydropdownValue == 'phase') spoty = sig.phase;
    else if(ydropdownValue == 'real') spoty = sig.real;
    else if(ydropdownValue == 'imag') spoty = sig.imag;
    spotlist = [];
    for(int i = 0; i < spotx.length; i++){
      spotlist.add(ChartData(spotx[i], spoty[i]));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppdata.bgcolor,
      body: Column(
        children: [
          const SizedBox(height: 100,),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width - 100,),
              Text("Grid", style: MyAppdata.styl,),
              Checkbox(value: grid,
                activeColor: Colors.orange,
                onChanged: (bool? val)=>{
                setState((){
                  if(grid) {
                  grid = false;
                  gridwidth = 0;
                } else {
                  grid = true;
                  gridwidth = 0.5;
                }})
              },),
            ],
          ),
          Center(
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    color: MyAppdata.bgcolor,
                    child: SfCartesianChart(
                      title: ChartTitle(text: '$ydropdownValue vs $xdropdownValue', textStyle: MyAppdata.styl),
                      primaryXAxis: NumericAxis(
                        majorGridLines: MajorGridLines(width: gridwidth),
                      ),
                      primaryYAxis: NumericAxis(
                          majorGridLines: MajorGridLines(width: gridwidth),
                      ),
                      zoomPanBehavior: ZoomPanBehavior(enablePinching: true, enableDoubleTapZooming: true, enablePanning: true),
                      series: <ChartSeries>[
                        LineSeries<ChartData, double>(dataSource: spotlist, xValueMapper: (ChartData data, _) => data.x, yValueMapper: (ChartData data, _) => data.y,
                        color: Colors.orange)
                      ],
                    ),
          ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    const SizedBox(width: 40,),
                    Text('X : ', style: MyAppdata.styl,),
                    const SizedBox(width: 20,),
                    DropdownButton<String>(
                      // Step 3.
                      value: xdropdownValue,
                      // Step 4.
                      items: <String>['t', 'n', 'f']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: MyAppdata.styl,
                          ),
                        );
                      }).toList(),
                      // Step 5.
                      onChanged: (String? newValue) {
                        setState(() {
                          xdropdownValue = newValue!;
                          setspots();
                        });
                      },
                    ),
                    const SizedBox(width: 40,),
                    Text('Y : ', style: MyAppdata.styl,),
                    const SizedBox(width: 20,),
                    DropdownButton<String>(
                      // Step 3.
                      value: ydropdownValue,
                      // Step 4.
                      items: <String>['xn', 'abs', 'phase', 'real', 'imag']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: MyAppdata.styl,
                          ),
                        );
                      }).toList(),
                      // Step 5.
                      onChanged: (String? newValue) {
                        setState(() {
                          ydropdownValue = newValue!;
                          setspots();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // const SizedBox(height: 30,),
        ],
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   // SystemChrome.setPreferredOrientations([
  //   //   DeviceOrientation.landscapeLeft,
  //   //   DeviceOrientation.landscapeRight,
  //   // ]);
  //   // final List<ChartData> chartData = [
  //   //   ChartData(0, 0),
  //   //   ChartData(1, 0.7),
  //   //   ChartData(2, 1.2),
  //   //   ChartData(3, 1.6),
  //   //   ChartData(4, 1.9)
  //   // ];
  //   return Scaffold(
  //     body: Center(
  //       child: Container(
  //         width: MediaQuery.of(context).size.width,
  //         height: MediaQuery.of(context).size.width,
  //         color: MyAppdata.bgcolor,
  //           child: SfCartesianChart(
  //             series: <ChartSeries>[
  //               LineSeries<ChartData, double>(dataSource: spotlist, xValueMapper: (ChartData data, _) => data.x, yValueMapper: (ChartData data, _) => data.y)
  //             ],
  //           )
  //         ),
  //       ),
  //     );
  // }

}


class ChartData {
  ChartData(this.x, this.y);
  final double x;
  final double y;
}
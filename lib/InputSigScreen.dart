import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'createScreen.dart';
import 'Keyboards.dart';
import 'package:function_tree/function_tree.dart';





class InputSignal{
  static TextEditingController time_i = TextEditingController();
  static TextEditingController time_f = TextEditingController();
  static TextEditingController expression = TextEditingController();
  static TextField expr = TextField(
    showCursor: false,
    style: MyAppdata.styl,
  readOnly: true,
  decoration: const InputDecoration(
  filled: false,
  labelText: 'Expression',
  labelStyle: MyAppdata.styl,
  fillColor: Colors.grey,
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(
  color: Colors.white
  )
  ),
  enabledBorder : OutlineInputBorder(
  borderSide: BorderSide(
  color: Colors.white
  )
  ),
  ),
  controller: expression,
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
    onTap: ()=>{
      tap()
    },
    onSubmitted: (String str)=>{
      untap()
    },

  );
  static Text samplen = Text("Samples : 0", style: MyAppdata.styl,);
  static var keyEnable;
  static var tap;
  static var untap;
  static var error;
  static var spanList = [];
  static var samples;
  static bool checkExpr(String s, BuildContext context){
    try{
        s.replaceAll('t', '0').interpret();
        return true;

    }catch(e){
      InputSignal.error();
      return false;
    }
  }
  static bool checkSpan(BuildContext context, StateSetter setState){
      try {
      if(((InputSignal.spanList.isEmpty)||(double.parse(time_i.text) >= double.parse(InputSignal.spanList.last[1])))&&(double.parse(time_f.text) - double.parse(time_i.text) > 0)){
        setState(() {
          samples = ((double.parse(time_f.text) - double.parse(time_i.text)) *
              (double.parse(Create.fsdata.text))).round();
          samplen = Text('Samples : ${(samples.round())}', style: MyAppdata.styl,);
          InputSignal.keyEnable = const Text('', style: MyAppdata.styl,);
        });
        return true;
      }
    else{
      if(((InputSignal.spanList.isEmpty)||(double.parse(time_i.text) < double.parse(InputSignal.spanList.last[1])))){
        setState((){
          InputSignal.keyEnable = Text('Start time cannot be before end of last span (${InputSignal.spanList.last[1]})', style: MyAppdata.styl,);
        });
      } else {
          setState(() {
            InputSignal.keyEnable = const Text(
              'Timespan not valid!',
              style: MyAppdata.styl,
            );
          });
        }
        return false;
    }
  }catch(e){
        setState((){
          InputSignal.keyEnable = const Text('Timespan not valid!', style: MyAppdata.styl,);
        });
        return false;
      }
    }

  static dialogBuilder(BuildContext context) {
    InputSignal.keyEnable = Text('');
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: const RoundedRectangleBorder(
          side: BorderSide(width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: MyAppdata.bgcolor,
        child : StatefulBuilder(
          builder:(BuildContext context, StateSetter setState){
            InputSignal.tap = ()=>{
              setState((){
                keyboardShow(context);
                // InputSignal.keyEnable = key.kb;
                // InfoPopupWidget()
              })
            };
            InputSignal.untap = ()=>{
              setState((){
                InputSignal.keyEnable = const Text('');
              })
            };
            InputSignal.error = ()=>{
              setState((){
                InputSignal.keyEnable = const Text('Signal Expression not valid!', style: MyAppdata.styl,);
              })
            };
            return Container(
              height: 440,
              width: 800,
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                child: Center(
                  child: Column(
                    children: [
                      InputSignal.expr,
                      const Spacer(flex:2),
                      Row(
                        children: [
                          const Text('Timespan : ', style: MyAppdata.styl,),
                          const Spacer(flex: 2,),
                          SizedBox(width: 70 ,
                              child: TextField(
                                style: MyAppdata.styl,
                                controller: time_i,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  filled: false,
                                  labelText: 'start',
                                  labelStyle: MyAppdata.styl,
                                  fillColor: Colors.grey,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white
                                      )
                                  ),
                                  enabledBorder : OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white
                                      )
                                  ),
                                ),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                                  onTap: ()=>{
                                      untap()
                                  },
                                  onChanged: (String str)=>{
                                        checkSpan(context, setState)
                                  }
                              ),),
                          const Spacer(flex: 2,),
                          SizedBox(width: 70,
                              child: TextField(
                                style: MyAppdata.styl,
                                controller: time_f,
                                keyboardType : TextInputType.number,
                                onTap: ()=>{
                                    untap()
                                  },
                                onChanged: (String str)=>{
                                  checkSpan(context, setState)
                                },
                                decoration: const InputDecoration(
                                  filled: false,
                                  labelText: 'end',
                                  labelStyle: MyAppdata.styl,
                                  fillColor: Colors.grey,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white
                                      )
                                  ),
                                  enabledBorder : OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white
                                      )
                                  ),
                                ),
                              ),),],
                      ),
                      const Spacer(flex: 5,),
                      InputSignal.samplen,
                      const Spacer(flex: 2,),
                      Spacer(flex: 2,),
                      InputSignal.keyEnable,
                      Spacer(flex: 4,),
                      Row(
                        children: [
                          TextButton(
                            child: const Text('Cancel', style: MyAppdata.styl,),
                            onPressed: () {
                              time_i.text = '';
                              time_f.text = '';
                              expression.text = '';
                              InputSignal.samplen = Text("Samples : 0", style: MyAppdata.styl,);
                              Navigator.of(context).pop();
                            },
                          ),
                          Spacer(),
                          TextButton(
                            child: const Text('Add', style: MyAppdata.styl,),
                            onPressed: () {
                              if(InputSignal.checkSpan(context, setState)&&
                                  InputSignal.checkExpr(expression.text, context)){
                                var span = [time_i.text.toString(), time_f.text.toString(), expression.text.toString(), samples];
                                    InputSignal.spanList.add(span);
                                  Navigator.of(context).pop();
                                  Create.addlist();
                                time_i.text = '';
                                time_f.text = '';
                                expression.text = '';
                                samples = 0;
                                InputSignal.samplen = Text("Samples : 0", style: MyAppdata.styl,);
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
        }
      ),
      );
    }
  );
}
//


// static EditSpan(BuildContext context, List ls) {
//     InputSignal.keyEnable = Text('');
//     return showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: const RoundedRectangleBorder(
//               side: BorderSide(width: 1),
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//             backgroundColor: MyAppdata.bgcolor,
//             child : StatefulBuilder(
//                 builder:(BuildContext context, StateSetter setState){
//                   InputSignal.tap = ()=>{
//                     setState((){
//                       InputSignal.keyEnable = key.kb;
//                     })
//                   };
//                   InputSignal.untap = ()=>{
//                     setState((){
//                       InputSignal.keyEnable = const Text('');
//                     })
//                   };
//                   InputSignal.error = ()=>{
//                     setState((){
//                       InputSignal.keyEnable = const Text('Signal Expression not valid!', style: MyAppdata.styl,);
//                     })
//                   };
//                   return Container(
//                     height: 480,
//                     width: 700,
//                     padding: const EdgeInsets.all(35),
//                     child: SizedBox(
//                       child: Center(
//                         child: Column(
//                           children: [
//                             const Center(child:Text('Edit', style: MyAppdata.bold_styl,)),
//                             const Spacer(flex:2),
//                             //expr
//                             TextField(
//                               showCursor: false,
//                               style: MyAppdata.styl,
//                               decoration: const InputDecoration(
//                                 filled: false,
//                                 labelText: 'Expression',
//                                 labelStyle: MyAppdata.styl,
//                                 fillColor: Colors.grey,
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.white
//                                     )
//                                 ),
//                                 enabledBorder : OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: Colors.white
//                                     )
//                                 ),
//                               ),
//                               controller: expression,
//                               inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
//                               onTap: ()=>{
//                                 tap()
//                               },
//                               onSubmitted: (String str)=>{
//                                 untap()
//                               },
//
//                             ),
//                             const Spacer(flex:2),
//                             Row(
//                               children: [
//                                 const Spacer(flex: 2,),
//                                 const Text('Timespan : ', style: MyAppdata.styl,),
//                                 const Spacer(flex: 2,),
//                                 SizedBox(width: 70 ,
//                                   child: TextField(
//                                       style: MyAppdata.styl,
//                                       controller: time_i,
//                                       decoration: const InputDecoration(
//                                         filled: false,
//                                         labelText: 'start',
//                                         labelStyle: MyAppdata.styl,
//                                         fillColor: Colors.grey,
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.white
//                                             )
//                                         ),
//                                         enabledBorder : OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.white
//                                             )
//                                         ),
//                                       ),
//                                       inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
//                                       onTap: ()=>{
//                                         untap()
//                                       },
//                                       onChanged: (String str)=>{
//                                         checkSpan(context, setState)
//                                       }
//                                   ),),
//                                 const Spacer(flex: 2,),
//                                 SizedBox(width: 70,
//                                   child: TextField(
//                                     style: MyAppdata.styl,
//                                     controller: time_f,
//                                     onTap: ()=>{
//                                       untap()
//                                     },
//                                     onChanged: (String str)=>{
//                                       checkSpan(context, setState)
//                                     },
//                                     decoration: const InputDecoration(
//                                       filled: false,
//                                       labelText: 'end',
//                                       labelStyle: MyAppdata.styl,
//                                       fillColor: Colors.grey,
//                                       focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.white
//                                           )
//                                       ),
//                                       enabledBorder : OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.white
//                                           )
//                                       ),
//                                     ),
//                                   ),),
//                                 const Spacer(flex: 5,),
//                                 InputSignal.samplen,
//                                 const Spacer(flex: 2,),],
//                             ),
//                             Spacer(flex: 2,),
//                             InputSignal.keyEnable,
//                             Spacer(flex: 4,),
//                             Row(
//                               children: [
//                                 TextButton(
//                                   child: const Text('Cancel', style: MyAppdata.styl,),
//                                   onPressed: () {
//                                     time_i.text = '';
//                                     time_f.text = '';
//                                     expression.text = '';
//                                     InputSignal.samplen = Text("Samples : 0", style: MyAppdata.styl,);
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                                 Spacer(),
//                                 TextButton(
//                                   child: const Text('Save', style: MyAppdata.styl,),
//                                   onPressed: () {
//                                     if(InputSignal.checkSpan(context, setState)&&
//                                         InputSignal.checkExpr(expression.text, context)){
//                                       var span = [time_i.text, time_f.text, expression.text, InputSignal.samples];
//                                       int ind = InputSignal.spanList.indexOf(ls);
//                                       InputSignal.spanList.remove(ls);
//                                       InputSignal.spanList.replaceRange(ind, ind, [span]);
//                                       time_i.text = '';
//                                       time_f.text = '';
//                                       expression.text = '';
//                                       InputSignal.samplen = const Text("Samples : 0", style: MyAppdata.styl,);
//                                       Navigator.of(context).pop();
//                                       Create.addlist();
//                                     }
//                                   },
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//             ),
//           );
//         }
//     );
//   }
}

class SignalData{
  List<dynamic> tSpans = [];
}

import 'dart:ui';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'HomeScreen.dart';
import 'jsonHandler.dart';
import 'JSONConstructor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'InputSigScreen.dart';
import 'package:function_tree/function_tree.dart';

List<Widget> tiles = [];


class Create{

  static backtoHome(BuildContext context){
    Navigator.of(context).popUntil(firstModalRoute);
    InputSignal.expression.text = '';
    InputSignal.time_i.text = '';
    InputSignal.time_f.text = '';
    fsdata.text = '';
    signame.text = '';
    tiles = [];
    InputSignal.spanList = [];
}
  static var flag1 = 0;
  static final TextEditingController signame = TextEditingController();
  static final TextEditingController fsdata = TextEditingController();
  static int flag = 0;
  static var namebox = SizedBox(
    width: 300,
    child: TextField(
      controller: Create.signame,
      style: MyAppdata.styl,
      decoration: const InputDecoration(
          labelText: 'Name of Signal',
          labelStyle: MyAppdata.styl,
          filled: true,
          fillColor: MyAppdata.bgcolor,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white
              )
          )
      ),
    ),
  );
  static var fsbox = SizedBox(
    width: 70,
    child: TextField(
      controller: Create.fsdata,
      keyboardType: TextInputType.number,
      style: MyAppdata.styl,
      decoration: const InputDecoration(
          labelText: 'Fs',
          labelStyle: MyAppdata.styl,
          filled: true,
          fillColor: MyAppdata.bgcolor,
          enabledBorder : OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white
              )
          )
      ),
      onChanged: (String s)=>{
        flag = 0
      },
      onTapOutside: (PointerDownEvent p)=>{
        if(flag == 0) {fsEdit()}
      },
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
    ),
  );
  static var tiles;
  static var scrl;
  static var bodycontainer;
  static var  addlist;
  static var fsEdit;
  static bool checkfs(BuildContext context){
    // InputSignal.dialogBuilder(context)
    if(Create.signame.text.isEmpty){
      emptynameDialouge(context);
      return false;
    }
    else if(Create.fsdata.text.isEmpty){
      emptyfsDialouge(context);
      return false;
    }
    else{
      try{
        Create.fsdata.text.interpret();
        return true;
      }catch(e){
        InvalidfsDialouge(context);
        return false;
      }
    }
  }
  static var lastrow;
  static AlertDialog creatingDialog =  AlertDialog(
  title: Center(
  child: Padding(
  padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        // The loading indicator
        CircularProgressIndicator(),
        SizedBox(
          height: 15,
        ),
        // Some text
        Text('Creating Signal...', style: TextStyle(
            color: Color.fromRGBO(150, 150, 150, 1),
            fontFamily: 'yourFont',
            fontSize: 22,
            fontWeight: FontWeight.w400),),
      ],
    ),
  ),
  ),
  backgroundColor: MyAppdata.bgcolor,
  );
  static var dialogflag = 0;
}

class CreateScreen extends StatefulWidget{
  const CreateScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreateScreen();
}


class _CreateScreen extends State<CreateScreen>{


  @override
  Widget build(BuildContext context){
      // var addtspan = InkWell(
      //   child: ListTile(
      //   leading: const Icon(
      //     Icons.add, size: 30, color: Color.fromRGBO(180, 180, 180, 1),),
      //   title: const Text('Add time span', style: MyAppdata.bold_styl),
      //   onTap: () => {
      //     if(Create.checkfs(context)){
      //       InputSignal.dialogBuilder(context)
      //     }
      //   },
      //   hoverColor: const Color.fromRGBO(0, 24, 32, 1.0),
      //   ),
      // );
      var addtspan = Row(
        children: [
          const SizedBox(width: 40, height: 60,),
          FloatingActionButton.extended(onPressed: () => {
          if(Create.checkfs(context)){
          InputSignal.dialogBuilder(context)
          }},
          backgroundColor: MyAppdata.barcolor,
          label: const Text('Add time span', style: MyAppdata.bold_styl),
          icon: const Icon(
                Icons.add, size: 30, color: Color.fromRGBO(180, 180, 180, 1),),),
        ],
      );
      tiles = [
        addtspan,];
      for(int i = 0; i < InputSignal.spanList.length; i++){
        tiles.add(spanRow(InputSignal.spanList[i]));
      }
      Create.scrl = SingleChildScrollView(child: Column(children: tiles,));
      Create.bodycontainer = SizedBox(
        height: 620,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15,),
              Row(
                children: [
                  SizedBox(width: 40,),
                  Create.namebox,
                  // SizedBox(width: 40,),
                ],
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  SizedBox(width: 40,),
                  Text('Sampling Frequency : ', style: MyAppdata.styl,),
                  SizedBox(width: 15,),
                  Create.fsbox,
                ],
              ),
              SizedBox(height: 10,),
              Create.scrl,
              // Spacer(flex: 1,),
            ],

          ),
        ),
      );
      Create.addlist = ()=>{
      setState((){
        for(int i = 0; i < InputSignal.spanList.length; i++){
                tiles.add(spanRow(InputSignal.spanList[i]));
            }
      })
      };
      Create.fsEdit = ()=>{
        if(Create.checkfs(context)){
            for (int i = 0; i < InputSignal.spanList.length; i++)
              {
                setState(() {
                  InputSignal.spanList[i][3] =
                      '${(Create.fsdata.text)}*(${InputSignal.spanList[i][1]} - ${InputSignal.spanList[i][0]})'
                          .interpret()
                          .round();
                })
              }
          },
        Create.flag = 1
        };
      Create.lastrow = Container(
        color: MyAppdata.bgcolor,
        child: Row(children:[
          SizedBox(width: 30, height: 45,),
          Container(
              color: MyAppdata.bgcolor,
              height: 40,
              width: 100,
              padding: const EdgeInsets.all(0),
              child: FloatingActionButton(
                heroTag: 'cancel1',
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7))
                  ),
                  backgroundColor: MyAppdata.bgcolor,
                  onPressed: () {
                    Create.backtoHome(context);
                  },
                  splashColor: MyAppdata.bgcolor,
                  child: Text('Cancel', style: MyAppdata.bold_styl)
              )
          ),
          // SizedBox(width: 1000,),
          Spacer(flex: 1,),
          Container(
              color: MyAppdata.bgcolor,
              height: 40,
              width: 100,
              padding: const EdgeInsets.all(0),
              child: FloatingActionButton(
                heroTag: 'save1',
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7))
                  ),
                  backgroundColor: MyAppdata.bgcolor,
                  onPressed: () {
                    if(tiles.length > 1 && Create.checkfs(context)){
                    jsonCreate1(
                        context,
                        Create.signame.text,
                        Create.fsdata.text.interpret() as double,
                        InputSignal.spanList);
                  }
                },
                  splashColor: MyAppdata.bgcolor,
                  child: Text('Save', style: MyAppdata.bold_styl)
              )
          ),
          SizedBox(width: 30, height: 45,),
        ]),
      );
      var appbar = AppBar(
          bottom: PreferredSize(preferredSize: const Size.fromHeight(60), child: Column(
            children: [
              Row(
                children: const [
                  SizedBox(width: 10,),
                  Text('Create Signal', style: MyAppdata.funcstyle,),
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Color.fromRGBO(180, 180, 180, 1),),
            onPressed: ()=>{
              Create.backtoHome(context),
            },
          )

      );;

    return Scaffold(
      appBar: appbar,
      resizeToAvoidBottomInset : false,
      backgroundColor: MyAppdata.bgcolor,
      body: Column(children : [
        Create.bodycontainer,
        // Container(height: 11, decoration: BoxDecoration(color: MyAppdata.barcolor),),
        Create.lastrow
      ]),
    );
  }
}

Future emptynameDialouge(BuildContext context) {
return showDialog(
context: context,
builder: (BuildContext context) {
return const AlertDialog(
  title: Center(
    child: Text('Signal Name Required !', style: TextStyle(
        color: Color.fromRGBO(150, 150, 150, 1),
        fontFamily: 'yourFont',
        fontSize: 24,
        fontWeight: FontWeight.w500),),
  ),
  backgroundColor: MyAppdata.bgcolor,
);
});
}

Future emptyfsDialouge(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Center(
            child: Text('Sampling Frequency Required !', style: TextStyle(
                color: Color.fromRGBO(150, 150, 150, 1),
                fontFamily: 'yourFont',
                fontSize: 24,
                fontWeight: FontWeight.w500),),
          ),
          backgroundColor: MyAppdata.bgcolor,
        );
      });
}

Future InvalidfsDialouge(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Center(
            child: Text('Invalid Sampling Frequency!', style: TextStyle(
                color: Color.fromRGBO(150, 150, 150, 1),
                fontFamily: 'yourFont',
                fontSize: 24,
                fontWeight: FontWeight.w500),),
          ),
          backgroundColor: MyAppdata.bgcolor,
        );
      });
}



Widget spanRow(List ls){
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: const [SizedBox(height: 10,)],
          ),
          Row(
            children: [
              // const SizedBox(width: 40,child: Icon(Icons.equalizer,size: 30, color: Color.fromRGBO(180, 180, 180, 1))),
              const SizedBox(width: 20,),
              SizedBox(width: 170, child: Text('${ls[2]}', style: MyAppdata.styl,
                  overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 5,),
              SizedBox(width: 45,child: Center(child: Text('${ls[0]}s', style: MyAppdata.styl,
                  overflow: TextOverflow.ellipsis))),
              const SizedBox(width: 5, child: Center(child: Text('-', style: MyAppdata.styl,
                  overflow: TextOverflow.ellipsis)),),
              SizedBox(width: 45, child: Center(child: Text('${ls[1]}s', style: MyAppdata.styl,
                  overflow: TextOverflow.ellipsis))),
              const SizedBox(width: 5,),
              SizedBox(width: 60,child: Center(child: Text('N : ${ls[3]}', style: MyAppdata.substyl,
                  overflow: TextOverflow.ellipsis))),
              // const Spacer(flex: 20,),,
              // const Spacer(flex: 1,),
              SizedBox(width: 30, child: InkWell(
                  onTap: (){
                    InputSignal.spanList.remove(ls);
                    Create.addlist();
                  },
                  splashColor: MyAppdata.bgcolor,
                  splashFactory: NoSplash.splashFactory,
                  child: Icon(Icons.delete_rounded,size: 25, color: Color.fromRGBO(180, 180, 180, 1)))),
              // const SizedBox(width: 5,),
              // const Spacer(flex: 2,),
            ],
          ),
          Row(
            children: const [SizedBox(height: 10,)],
          )
        ],
      ),
    );
}
import 'package:flutter/material.dart';
import 'main.dart';

import 'createScreen.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: MyAppdata.keybgcolor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 160,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                  color: MyAppdata.menucolor,
                  ),
              child: Column(
                children: [
                  SizedBox(height: 45,),
                  Row(
                    children: const [
                      Text(
                        'Operations',
                        style: MyAppdata.menustyle,
                      ),
                    ],
                  ),
                ],
              )
            ),
          ),
          InkWell(
            // hoverColor: MyAppdata.bgcolor,
            onTap: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => CreateScreen()))
          },
            splashFactory: InkRipple.splashFactory,
            child: const ListTile(
              leading: Icon(Icons.add_chart, color: Color.fromRGBO(180, 180, 180, 1),),
              title: Text('Create', style: MyAppdata.styl,),
            ),
          ),
        ],
      ),
    );
  }
}


// var bodycontainer = InkWell(
//   child: Container(
//     color: const Color.fromRGBO(0, 0, 0, 0),
//     child: wid,
//   ),
//   onTap: () => {},
//   splashFactory: NoSplash.splashFactory,
//   splashColor: const Color.fromRGBO(0, 0, 0, 0),
//   mouseCursor: MouseCursor.defer,
//   highlightColor: const Color.fromRGBO(0, 0, 0, 0),
// );
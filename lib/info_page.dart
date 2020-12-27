import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class InfoPage extends StatelessWidget {
  static String get getOSinfo {
    var os = Platform.operatingSystem;
    var osver = Platform.operatingSystemVersion;
    return '$os $osver';
  }
  static get ver => '1.0.0';
  var desc = '''
Version: $ver
Developer: 크로스플랫폼 주의자
Icon: 스님(김태민)
Date: 2020-12-30
Flutter: 1.26.0-2.0.pre.134
OS: $getOSinfo
  ''';
  @override
  Widget build(BuildContext context) {
    var med = MediaQuery.of(context);
    var empty = (med.size.width)*0.1;
    var textAlign = TextAlign.left;
    var titleTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold );
    var stdTextStyle = TextStyle(fontSize: 16);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Info'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
            Image.asset('assets/icon-nobg.png', height: 300,),
            Container(
              padding: EdgeInsets.fromLTRB(empty,10,empty,0),
              child: Column(
              children: <Widget>[
                Center(child: 
                  Text('Youtube Download', textAlign: TextAlign.center, style: titleTextStyle,),
                ),
                Text(
                  '$desc', textAlign: textAlign, style: stdTextStyle,
                  ),  
              ],
            ),

            ),
            
          ],)


          
      )
    );
  }
}
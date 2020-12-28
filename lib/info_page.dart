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
Icon: 스님(김태민)
Date: 2020-12-30
Flutter: 1.26.0-2.0.pre.134
OS: $getOSinfo

저작권 법 제30조 (사적이용을 위한 복제)
공표된 저작물을 영리를 목적으로 하지 아니하고 개인적으로 이용하거나 가정 및 이에 준하는 한정된 범위 안에서 이용하는 경우에는 그 이용자는 이를 복제할 수 있다. 다만, 공중의 사용에 제공하기 위하여 설치된 복사기기에 의한 복제는 그러하지 아니하다.

그러니 다운 받은 것을 절대로 공개된 곳에 올리지 마세요 !!
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
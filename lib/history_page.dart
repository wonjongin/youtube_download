import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class HistoryPage extends StatelessWidget {
var test = 'Test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('History'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('$test'),
            CupertinoButton(
              onPressed: () async {
                var localPath = await getApplicationDocumentsDirectory();
                final path = '$localPath/history.json';
                var file = File('$path');
                var data = file.readAsStringSync();
                print('$data');
              },
              child: Text('click'),
            )

          ],
        ),)
    );
  }
}
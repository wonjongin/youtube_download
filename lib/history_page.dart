import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_download/history.dart';
import 'package:open_file/open_file.dart';

class HistoryPage extends StatefulWidget{
  HistoryPageState createState()=> HistoryPageState();
}


class HistoryPageState extends State<HistoryPage> {
  var test = 'Test';
  var historyData = <History>[];

  List<History> parsingHistory(String strData){
    List<History> res = <History>[];
    print('MyLog: 001');
    List jsonData = jsonDecode('$strData');
    print('MyLog: 002');
    for(int i = 0; i<jsonData.length; i++){
      print('MyLog: $i:0');
      print('${jsonData[i]['id']}');
      Map<String, dynamic> tempMap = jsonData[i];
      print('MyrLog: $i:1');
      // var oneHistory = History(id: '${tempMap['id']}',thumbNail: '${tempMap['thumbNail']}',date: '${tempMap['date']}',size: '${tempMap['size']}',path: '${tempMap['path']}');
      var oneHistory = History.fromMap(tempMap);
      print('MyLog: $oneHistory');
      res.add(oneHistory); 
      print('MyLog: $i:2');
    }
    print('MyLog: 003');
    return res;
  }

  void deleteHistory() async {
    var dir = await getExternalStorageDirectory();
    final path = '${dir.path}/history.json';
    final file = File('$path');
    await file.delete();
  }

  void reallyDel() {
    showDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text('정말요?', style: TextStyle(color: Colors.red),),
        content: Text('정말로 기록을 삭제하시겠어요??'),
        actions: [
          FlatButton(onPressed:(){deleteHistory(); Navigator.pop(context);} , child: Text('예')),
          FlatButton(onPressed:(){Navigator.pop(context);}, child: Text('아니오'))
        ],
      );
    });
  }
  

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }
  void asyncMethod() async {
    try{
    var externalDir = await getExternalStorageDirectory();
    final path = '${externalDir.path}/history.json';
    var file = File('$path');
    var data = file.readAsStringSync();
    print('$data');
    setState(() {
      historyData = parsingHistory(data);
      test = '$data';
    });
    } on FileSystemException {
      setState(() {
        test = '기록이 없습니다.';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('History'),
      ),
      body: _historyBuilder(),
      );
  }

  Widget _historyBuilder() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: historyData.length,
      itemBuilder: (BuildContext context, int index){
        // if(index.isOdd) return Divider();
        return _eachHistory(historyData[historyData.length-index-1]); //히스토리개수랑 객체 받아야함
      }
      );
  }
  Widget _eachHistory(History history) {
    var historyMap = history.toMap();
    String path = historyMap['path'];
    var splittedPath = path.split('/');
    var title = '${splittedPath[splittedPath.length-1]}';
    String id = historyMap['id'];
    int size = int.parse('${historyMap['size']}');
    double sizeMB = ((size/1024).floorToDouble())/1000;
    String date = '${historyMap['date']}';

    return ListTile(
      leading: Image.network('${historyMap['thumbNail']}'),
      title: Text('$id'),
      subtitle: Text('경로: ${path.replaceAll('/storage/emulated/0/', '/')}\n용량: $sizeMB MB\n날짜: $date'),
      trailing: Row(    
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CupertinoButton(
            onPressed: (){
              OpenFile.open('$path');
            },
            color: Colors.orange,
            borderRadius: BorderRadius.circular(30.0),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Icon(CupertinoIcons.play, color: Colors.white,),
            // Text('파일 열기', style: TextStyle(color: Colors.white),),
          ),
        ]
      )
    );
  }

}
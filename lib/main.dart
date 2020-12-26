import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share/share.dart';import 'package:open_file/open_file.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Download',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Youtube Download'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String inputs = '';
  String res = '';
  var yt = YoutubeExplode();
  var fileName = 'default';
  var fileTypeId = 0;
  var fileType = ['.파일형식', '.m4a', '.mp3', '.mp4']; 
  var isProgressing = false;
  var customPath = '/storage/emulated/0';
  var thumbnailPath = 'https://logos-world.net/wp-content/uploads/2020/04/YouTube-Emblem.png';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<String> get _externalPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }
  String get _rootPath {
    return '/storage/emulated/0';
  }
  void setRes(String str){
    setState(() {
      res = str;
    });
  }
  String _cleanURL(String fullURL){
    String res;
    if(fullURL.contains('https://www.youtube.com/watch?v=')){
      res = fullURL.replaceAll('https://www.youtube.com/watch?v=', '');
    } else if(fullURL.contains('https://m.youtube.com/watch?v=')){
      res = fullURL.replaceAll('https://m.youtube.com/watch?v=', '');
    } else if(fullURL.contains('https://youtu.be/')){
      res = fullURL.replaceAll('https://youtu.be/', '');
    } else if(fullURL.length == 11){
      res = fullURL;
    } else {
      res = 'Unable URL';
    }
    return res;
  }
  Future<void> _downloadAudio() async {
    try{
    // var path = await _localPath;
    storagePermission();
    var path = _rootPath;
    inputs = _cleanURL(inputs);
    setState(() {
      res = 'Starting...';
      isProgressing = true;
      thumbnailPath = 'https://img.youtube.com/vi/$inputs/0.jpg';
    });
    setRes('Loading Video Info...');
    var manifest = await yt.videos.streamsClient.getManifest('$inputs');
    setRes('Get Metadata...');
    var streamInfo = manifest.audioOnly.withHighestBitrate();
    
    if (streamInfo != null) {
      setRes('Get the actual stream...');
      var stream = yt.videos.streamsClient.get(streamInfo);
      
      setRes('Creating a file...');
      var file = File('$customPath/$fileName${fileType[fileTypeId]}');
      var fileStream = file.openWrite();
      setRes('Writing on the file...');
      // Pipe all the content of the stream into the file.
      await stream.pipe(fileStream);

      // Close the file.
      await fileStream.flush();
      setRes('Closing the file...');
      await fileStream.close();
    }
    var myDir = new Directory(await _localPath);
    myDir.list(recursive: true, followLinks: false)
    .listen((FileSystemEntity entity) {
      print('My Log: ${entity.path}');
    });

    var file = File('$customPath/$fileName${fileType[fileTypeId]}');
    print('My Log: ${file.lengthSync()}');
    setState(() {
      res = 'Done!';
      _counter++;
      isProgressing = false;
    });}
    catch(e){
      setRes('Error');
      setState(() {
      isProgressing = false;
      });
      showDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text('Error', style: TextStyle(color: Colors.red),),
        content: Text('$e'),
        actions: [
          FlatButton(onPressed:(){Navigator.pop(context);} , child: Text('close'))
        ],
      );
    });
    }
  }
  Future<void> _fileTest() async{
    storagePermission();
    setState(() {
      res = 'Writing';
    });
    var exPath = await _externalPath;
    // File file = File('$exPath/MyTest.txt');
    File file = File('$_rootPath/MyTest.txt');
    print('MyLog: ${file.path}');
    // var str = 'Hello world $_counter';
    file.writeAsStringSync('$_counter: $inputs');
    setState(() {
      res = 'Done';
    });
  }
  void storagePermission() async {
    var status = await Permission.storage.status;
    // if(status.isUndetermined){
    //   // 아직 권한 물어 본 적이 없음
    //   Permission.storage.request();
    // }
    if(status.isPermanentlyDenied){
      openAppSettings();
    }
    Permission.storage.request();
  }
  Future<String> getPathFromFilePicker() async {
    var result = await FilePicker.platform.getDirectoryPath();
    return result;
  }
  void goShare(){
    Share.shareFiles(['$customPath/$fileName${fileType[fileTypeId]}']);
  }
  void goOpen(){
    OpenFile.open('$customPath/$fileName${fileType[fileTypeId]}');
  }
  showPicker(){
    showModalBottomSheet(
      context: context, builder: (BuildContext context) {
      return Wrap(
        children: <Widget>[
          Container(
            height: 240,
            child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        fileTypeId = value;
                      });
                    },
                    itemExtent: 50,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(30,0,30,0),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.check_mark),
                            Text(' 파일형식을 선택하십시오'),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30,0,30,0),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.music_note_2),
                            Text(' Audio: m4a'),
                          ],
                        ),
                      ),
                      
                      Container(
                        padding: EdgeInsets.fromLTRB(30,0,30,0),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.music_note_2),
                            Text(' Audio: mp3'),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30,0,30,0),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.play_rectangle),
                            Text(' Video: mp4'),
                          ],
                        )
                      ),
                      ]
                  ),
          ),
          
                  ]
                  )
                  ;
    });
  }

  void _showError() {
    showDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text('Error', style: TextStyle(color: Colors.red),),
        content: Text('에러가 발생했습니다. 앱을 재실행 해주세요'),
        actions: [
          FlatButton(onPressed:(){Navigator.pop(context);} , child: Text('close'))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final med = MediaQuery.of(context);
    var fullw = (med.size.width)*0.9;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        middle: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network('$thumbnailPath', width: med.size.width,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: (fullw)*0.3,
                  child: Text(
                  'Url',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,           
                  ),
                ),
                
                Container(
                  width: (fullw)*0.7,
                  child: TextField(
                    style: TextStyle(fontSize: 20, color: Colors.red),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(hintText: '링크 입력'),
                    onChanged: (String str) {
                      setState(() => inputs = str);
                      },
                    ),
                )
                
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: (fullw)*0.3,
                  child: Text(
                  '파일이름',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),                
                  ),
                ),
                
                Container(
                  width: (fullw)*0.4,
                  child: TextField(
                    style: TextStyle(fontSize: 20, color: Colors.red),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(hintText: '파일이름 입력'),
                    onChanged: (String str) {
                      setState(() => fileName = str);
                      },
                    ),
                ),

                Container(
                  width: (fullw)*0.3,
                  child: CupertinoButton(
                    onPressed: showPicker,
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30.0),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child:
                        // Icon(Icons.text_fields),
                        Text('${fileType[fileTypeId]}', textAlign: TextAlign.center,style: TextStyle(color: Colors.white),
                        )
                  ),
                )
                
              ],
            ),
            Container(
              width: fullw,
              child: CupertinoButton(
                onPressed: () async{ 
                  var path = await getPathFromFilePicker();
                  var root = await _rootPath;
                  if(path == null){
                    setState(() {
                      customPath = '$_rootPath';
                    });
                  } else{
                    setState(() { 
                      customPath = path;
                      res = res;
                    });
                  }
                  },
                color: Colors.orange,
                borderRadius: BorderRadius.circular(30.0),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Center(
                  child: Row(
                  children: [
                    Icon(CupertinoIcons.doc, color: Colors.white,),
                    Text(' 다운로드 경로 설정하기', style: TextStyle(color: Colors.white))
                  ],
                  ),
              ),
            )),
            Text(
              '저장경로: $customPath/$fileName${fileType[fileTypeId]}'.replaceAll('$_rootPath', 'Root'),
            ),
            Text(
              '$res',
              style: TextStyle(fontSize: 30),
            ),
            Container(
              width: fullw,
              child: CupertinoButton(
              onPressed: isProgressing? _showError:_downloadAudio,
              color: Colors.orange,
              borderRadius: BorderRadius.circular(30.0),
              child: Center(child: Row(
                children: <Widget>[
                Icon(CupertinoIcons.cloud_download, color: Colors.white,),
                Text(" 다운로드", textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                ]
              ))
              
            ),
            ),
            Padding(padding: EdgeInsets.all(15)),
            Row(children: [
              Padding(padding: EdgeInsets.fromLTRB((med.size.width)*0.05, 0, 0, 0)),
              Container(
              width: fullw*0.45,
              child: CupertinoButton(
              // onPressed: _fileTest,
              // onPressed: _showError,
              onPressed: goShare,
              color: Colors.orange,
              borderRadius: BorderRadius.circular(30.0),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Center(child: Row(
                children: <Widget>[
                Icon(CupertinoIcons.share, color: Colors.white,),
                Text(" 공유하기!", textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                ]
              )
              )
              
            ),),
            Padding(padding: EdgeInsets.all(fullw*0.05)),
            Container(
              width: fullw*0.45,
              child: CupertinoButton(
              // onPressed: _fileTest,
              // onPressed: _showError,
              onPressed: goOpen,
              color: Colors.orange,
              borderRadius: BorderRadius.circular(30.0),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Center(child: Row(
                children: <Widget>[
                Icon(CupertinoIcons.folder_open, color: Colors.white,),
                Text(" 파일열기!", textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                ]
              )
              )
              
            ),),]
            
            ),
            
          ],
        ),
      ),
      )
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _downloadAudio,
      //   tooltip: 'Download',
      //   child: Icon(Icons.cloud_download),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';


import 'package:camera/camera.dart';
import 'package:permissions/camera_screen.dart';
import 'package:permissions/phonelogs_screen.dart';
import 'package:oktoast/oktoast.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return OKToast(
          child: MaterialApp(
        title: 'Flutter Permissions',
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
          primarySwatch: Colors.deepPurple,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Permissions'),
      ),
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
  
  void _incrementCounter() {
    
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

openCamera(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: cameras.first,),
      ),
    );
  }

openPhonelogs(){
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhonelogsScreen(),
      ),
    );
}

checkallpermission_opencamera() async{
  Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();

    if(statuses[Permission.camera].isGranted){
      if(statuses[Permission.microphone].isGranted){
        openCamera();
      }else{
        showToast("Camera needs to access your microphone, please provide permission", position: ToastPosition.bottom);
      }
    }else{
      showToast("Provide Camera permission to use camera.", position: ToastPosition.bottom);
    }
}
  checkpermission_opencamera() async{
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;
    
    print(cameraStatus);
    print(microphoneStatus);
    //cameraStatus.isGranted == has access to application
    //cameraStatus.isDenied == does not have access to application, you can request again for the permission. 
    //cameraStatus.isPermanentlyDenied == does not have access to application, you cannot request again for the permission. 
    //cameraStatus.isRestricted == because of security/parental control you cannot use this permission. 
    //cameraStatus.isUndetermined == permission has not asked before. 
    
    if (!cameraStatus.isGranted)
      await Permission.camera.request();
      
    if (!microphoneStatus.isGranted)
      await Permission.microphone.request();
    
    if(await Permission.camera.isGranted){
      if(await Permission.microphone.isGranted){
        openCamera();
      }else{
        showToast("Camera needs to access your microphone, please provide permission", position: ToastPosition.bottom);
      }
    }else{
      showToast("Provide Camera permission to use camera.", position: ToastPosition.bottom);
    } 
  }

  checkpermission_phone_logs() async{
    if(await Permission.phone.request().isGranted){
      openPhonelogs();
    }else {
      showToast("Provide Phone permission to make a call and view logs.", position: ToastPosition.bottom);
    }
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                          child: IconButton(onPressed: checkpermission_opencamera, icon: Icon(Icons.camera), iconSize: 42, 
              color: Colors.white,), color: Colors.amber, width: MediaQuery.of(context).size.width, height: (MediaQuery.of(context).size.height - 80) / 2,
            ),
            Container(
                          child: IconButton(onPressed: checkpermission_phone_logs, icon: Icon(Icons.phone), iconSize: 42,
              color: Colors.white), color: Colors.deepPurple, width: MediaQuery.of(context).size.width, height: (MediaQuery.of(context).size.height - 80) / 2,),
            
          ],
        ),
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

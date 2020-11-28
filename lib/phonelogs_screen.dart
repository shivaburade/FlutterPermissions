import 'package:flutter/material.dart';
import './phone_textfield.dart';
import 'package:call_log/call_log.dart';
import './callLogs.dart';

class PhonelogsScreen extends StatefulWidget {
  @override
  _PhonelogsScreenState createState() => _PhonelogsScreenState();
}

class _PhonelogsScreenState extends State<PhonelogsScreen> with  WidgetsBindingObserver {
  //Iterable<CallLogEntry> entries;
  PhoneTextField pt = new PhoneTextField();
  CallLogs cl = new CallLogs();

  AppLifecycleState _notification;
  Future<Iterable<CallLogEntry>> logs;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logs = cl.getCallLogs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (AppLifecycleState.resumed == state){
    setState(() {
        logs = cl.getCallLogs();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone"),),
      body: Column(
        children: [
          pt,
          //TextField(controller: t1, decoration: InputDecoration(labelText: "Phone number", contentPadding: EdgeInsets.all(10), suffixIcon: IconButton(icon: Icon(Icons.phone), onPressed: (){print("pressed");})),keyboardType: TextInputType.phone, textInputAction: TextInputAction.done, onSubmitted: (value) => call(value),),
          FutureBuilder(future:  logs,builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              Iterable<CallLogEntry> entries = snapshot.data;
              return Expanded(
                child: ListView.builder(itemBuilder: (context, index){
                  
                  return GestureDetector( child: Card(
                        child: ListTile(
                        leading: cl.getAvator(entries.elementAt(index).callType),
                        title: cl.getTitle(entries.elementAt(index)),
                        subtitle: Text(cl.formatDate(new DateTime.fromMillisecondsSinceEpoch(entries.elementAt(index).timestamp)) + "\n" + cl.getTime(entries.elementAt(index).duration)),
                        isThreeLine: true,
                        trailing: IconButton(icon: Icon(Icons.phone), color: Colors.green, onPressed: (){
                          cl.call(entries.elementAt(index).number);
                        }),
                      ),
                  ), onLongPress: () => pt.update(entries.elementAt(index).number.toString()),
                  );
                }, itemCount: entries.length,
                
                ),
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          })

        ],
      ),
    );
  }
}
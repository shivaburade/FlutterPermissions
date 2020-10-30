import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:call_log/call_log.dart';

class PhonelogsScreen extends StatefulWidget {
  @override
  _PhonelogsScreenState createState() => _PhonelogsScreenState();
}

class _PhonelogsScreenState extends State<PhonelogsScreen> {
  //Iterable<CallLogEntry> entries;
  TextEditingController t1 = TextEditingController();
  void call(String text) async{
     bool res = await FlutterPhoneDirectCaller.callNumber(text);
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone"),),
      body: Column(
        children: [
          TextField(controller: t1, decoration: InputDecoration(labelText: "Phone number"),keyboardType: TextInputType.phone, textInputAction: TextInputAction.done, onSubmitted: (value) => call(value),),
           FlatButton(onPressed: (){
             call(t1.text);
             }
           , child: Text("Call")),
          FutureBuilder(future:  CallLog.get(),builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              Iterable<CallLogEntry> entries = snapshot.data;
              return Expanded(
                child: ListView.builder(itemBuilder: (context, index){
                  return ListTile(
                      leading: CircleAvatar(maxRadius: 30, foregroundColor: Colors.green, backgroundColor: Colors.green,),
                      title: Text(entries.elementAt(index).number),
                      subtitle: Text(entries.elementAt(index).duration.toString() + "s"),
                      trailing: IconButton(icon: Icon(Icons.phone), color: Colors.green, onPressed: (){
                        call(entries.elementAt(index).number);
                      }),
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
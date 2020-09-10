// import 'dart:html';

import 'package:TodoList/msgModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo List',
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
        // primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: deprecated_member_use
  final firestoreInstance = Firestore.instance;
  TextEditingController msg = TextEditingController();
  List<MsgModel> todoList = [];
  bool isdelete = false;
  // int i =-1;

  void _addTask(String msg) {
    if (msg.length > 0) {
      DocumentReference documentReference =
          Firestore.instance.collection("todolist").doc();
      Map<String, String> todos = {'task': msg};
      // firestoreInstance.collection("todolist").add({'task': msg});
      documentReference
          .setData(todos)
          .whenComplete(() => {print("$msg Created ${documentReference.id}")});
    }
  }

  // @override
  // void initState() {
  //   // _onPressed();
  //   // TODO: implement initState
  //   print(firestoreInstance.collection("todolist").snapshots().length);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        centerTitle: true,
        title: Text(
          "ToDo List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            // isScrollControlled: true,
            // clipBehavior: ,
            enableDrag: true,
            backgroundColor: Colors.red[200].withOpacity(0.0),
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Colors.transparent,
                child: Container(
                  // height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1.0,
                      color: Colors.redAccent[100],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "TODO Task",
                          style: TextStyle(
                              color: Colors.blue[300],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20),
                        child: TextField(
                          controller: msg,
                          autocorrect: true,
                          decoration: InputDecoration(
                            // labelStyle: TextStyle(color:Colors.green),
                            hintText: "Enter text to add in todo",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.green[100]),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RaisedButton(
                          onPressed: () {
                            print(msg.text);
                            todoList.add(MsgModel(msgText: msg.text));
                            _addTask(msg.text);
                            setState(() {
                              msg.clear();
                            });
                            Navigator.of(context).pop();
                            // _onPressed();
                          },
                          child: Text(
                            "Add To ToDoList",
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold),
                          ),
                          color: Colors.redAccent[100],
                          elevation: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        elevation: 5.0,
        backgroundColor: Colors.redAccent,
        child: Icon(
          Icons.add,
          color: Colors.white60,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Color(0XFCF6F5FF),
                color: Color(0XFCF6F5FF),
                // color: Color(0XFFECEFF1),
                // color: Color(0XFFD7CCC8),
                borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.yMMMd().format(
                        DateTime.now(),
                      ),
                      style: TextStyle(
                        color: Color(0XFFBA68C8),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text("Tasks to Complete",style: TextStyle(
                        // color: Color(0XFFD7CCC8),
                        color: Color(0XFF795548),
                        // color: Color(0XFFECEFF1),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      
                    ),),
                  ],
                ),

              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: StreamBuilder(
                stream: firestoreInstance.collection("todolist").snapshots(),
                builder: (context, snapshots) {
                  if(snapshots.data == null) return CircularProgressIndicator(
                    // valueColor: Colors.red,
                  );
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshots.data.documents.length,
                    itemBuilder: (context, index) {
                      // DocumentSnapshot documentSnapshot=snapshots.data.documents[index];
                      DocumentSnapshot data = snapshots.data.documents[index];
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        child: Material(
                          color: Colors.white,
                          elevation: 10,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              // contentPadding: EdgeInsets.all(2),
                              leading: Icon(
                                Icons.list,
                                color: Colors.green,
                              ),
                              title: Text(data.get('task')),
                              trailing: InkWell(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.deepOrange,
                                ),
                                onTap: () {
                                  // firestoreInstance.collection("todolist").document(data.id);
                                  data.reference.delete();
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

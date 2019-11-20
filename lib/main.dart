import 'dart:convert';
import 'package:heutagogy/lessons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'data_models.dart';
import 'json_read_write.dart';

void main() {
  runApp(MyApp());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data;
  LessonData abcd;
  final JsonEncoder jsonEncoder = new JsonEncoder.withIndent('    ');
  @override
  void initState() {
    data = "";
    abcd = LessonData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
          child: Column(
            children: <Widget>[
              (data == "") ? Text("Welcome") : Text(""),
              Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              RaisedButton(
                child:
                    (data == "") ? Text("UpdateData") : Text("Let\'s Start!"),
                onPressed: () {
                  fetchData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchData() async {
    var loaded = await readData();
    if (loaded != "Nothing saved yet!") {
      setState(() {
        data = loaded;
      });
    }
    if (data == "") {
      final response =
          await http.get("https://1ashutosh.pythonanywhere.com/api/lesson/1");
      if (response.statusCode == 200) {
        String body = response.body;
        setState(() {
          data = body;
        });
      } else {
        setState(() {
          data = "Unable to connect!";
        });
        throw Exception("Unable to load!");
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LessonsPage(data)));
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heutagogy',
      theme: ThemeData(fontFamily: 'Quicksand'),
      home: MyHomePage(),
    );
  }
}

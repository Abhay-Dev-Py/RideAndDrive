import 'package:flutter/material.dart';
import 'package:production_app/PythonApi/API.dart';
import 'dart:convert';

void main() => runApp(MyApp1());

class MyApp1 extends StatefulWidget {
  static const String idScreen = "PythonMain";
  @override
  _MyApp1State createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  String url;

  var Data;

  String QueryText = 'Query';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PYTHON AND FLUTTER'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value) {
                  url = 'http://10.0.2.2:5000/api?Query=' + value.toString();
                },
                decoration: InputDecoration(
                    hintText: 'Search Anything Here',
                    suffixIcon: GestureDetector(
                        onTap: () async {
                          print('A');
                          Data = await getData(url);
                          print('B');
                          var DecodedData = jsonDecode(Data);
                          print('C');
                          setState(() {
                            QueryText = DecodedData['Query'].toString();
                            print("Result -->"+DecodedData);
                          });
                        },
                        child: Icon(Icons.search))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                QueryText,
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
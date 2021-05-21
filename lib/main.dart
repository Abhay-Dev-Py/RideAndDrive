import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:production_app/AllScreens/PythonApiTest.dart';
import 'package:production_app/AllScreens/loginScreen.dart';
import 'package:production_app/AllScreens/mainScreen.dart';
import 'package:production_app/AllScreens/registerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:production_app/MachineLearningTools/UserInterface.dart';
import 'package:provider/provider.dart';

import 'DataHandler/appData.dart';
//import 'package:production_app/MachineLearningTools/vision-text.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(

          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //home: MyApp2(),

        initialRoute: MainScreen.idScreen,
        routes: {
          RegisterScreen.idScreen: (context) => RegisterScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
        },
      ),
    );
  }
}

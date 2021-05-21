import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:production_app/AllScreens/loginScreen.dart';
import 'package:production_app/AllScreens/mainScreen.dart';
import 'package:production_app/Authentication/Auth.dart';
import 'package:production_app/main.dart';
import 'package:production_app/Firestore/FirestoreFunctions.dart';
DatabaseReference userRef = FirebaseDatabase.instance.reference().child('uber-clone-e9d36-default-rtdb');
class RegisterScreen extends StatelessWidget {
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  static const String idScreen = "Register";
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passswordC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(

            children: <Widget>[
              SizedBox(height: 1.0,),
              Image(
                image: AssetImage("images/logo.jpg"),
                width: 350.0,
                height: 350.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                "Register",
                style: TextStyle(fontSize: 24.0,fontFamily:"Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameC,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),

                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 10.0,

                        ),
                      ),
                      style : TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,

                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneC,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passswordC,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0,),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      onPressed: (){
                        print('Create Account Clicked');

                        if(nameC.text.length < 1)
                          {
                            displayToastMsg("Name Must be atleast 3 chars", context);
                          }
                        else if(!emailC.text.contains('@'))
                          {
                            displayToastMsg('Invalid Email format', context);
                          }
                        else if(phoneC.text.length != 10)
                          {
                            displayToastMsg('Invalid Phone no.', context);
                          }
                        else if(passswordC.text.length < 0)
                          {
                            displayToastMsg("Must be atleast 3 chars", context);
                          }
                        else
                          {
                            registerNewUser(context);

                          }
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
              FlatButton(
                child: Text(
                  "Already have an acc? Login here",
                ),
                onPressed :(){
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async
  {
      await Authenticate().SignInWithEmailPassword(emailC.text.trim(),passswordC.text.trim(),nameC.text.trim(),phoneC.text.trim(),context,idScreen);

  }
  displayToastMsg(String message,BuildContext context)
  {
    Fluttertoast.showToast(msg: message);
  }
}

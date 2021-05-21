import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:production_app/AllScreens/registerScreen.dart';
import 'package:production_app/Authentication/Auth.dart';

import 'mainScreen.dart';
class LoginScreen extends StatelessWidget {
  static const String idScreen = "Login";
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            
            children: <Widget>[
              SizedBox(height: 35.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 350.0,
                height: 350.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                "Login",
                style: TextStyle(fontSize: 24.0,fontFamily:"Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
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
                      controller: passwordC,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
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
                        print('Login Clicked');
                        loginAndAuthenticate(context);
                      },
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
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
                  "Do not have an acc? register here",
                ),
                onPressed :(){
                  Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.idScreen, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticate(BuildContext context) async
  {

    /*UserCredential user;
    try
    {
      user = await _firebaseAuth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passwordC.text
      );
    }
    catch(e)
    {
      print(e.toString());
      displayToastMsg("Error :- "+e.toString(),context);
    }
    finally
    {
      if (user != null)
        {
          print('Sign In successful!');

        }
      else
        {
          print("Unsuccessful Sign in!");
        }
    }*/
    var user = await Authenticate().SignInWithEmailPassword(emailC.text.trim(), passwordC.text.trim(),null,null, context, idScreen);
  }
  displayToastMsg(String message,BuildContext context)
  {
    Fluttertoast.showToast(msg: message);
  }
}

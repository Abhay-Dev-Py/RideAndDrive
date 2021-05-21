import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:production_app/AllScreens/loginScreen.dart';
import 'package:production_app/AllScreens/mainScreen.dart';
import 'package:production_app/AllScreens/registerScreen.dart';
import 'package:production_app/Firestore/FirestoreFunctions.dart';
class Authenticate
{
  String uid;
  BuildContext ctx;
  signInWithEmailPassword(String email,String password) async
  {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    UserCredential user;
    user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      User us = _firebaseAuth.currentUser;
      uid = us.uid;
      print("HELOOOO "+uid);
      Navigator.pushNamedAndRemoveUntil(ctx, MainScreen.idScreen, (route) => false,arguments: {"userID":uid});
    }).catchError((e)
    {
      print("Error Signing in ");
      Fluttertoast.showToast(msg: "User Not Found!");
    }
    );
  }
  //Create User With Email and Password
  CreateUserWithEmailPassword(String email,String password,String name,String phoneNo) async
  {
    /*final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    //UserCredential user;
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
    User us = _firebaseAuth.currentUser;
    uid = us.uid;
    print("HELOOOO "+uid);
    await FirestoreService().createUserProfile(name,email,phoneNo,ctx,uid );
    Navigator.pushNamedAndRemoveUntil(ctx, MainScreen.idScreen, (route) => false,arguments: {"userID":uid});
     */
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final User firebaseUser = (
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      ).catchError((errMsg){
        print('In catch error block '+errMsg.toString());
      })
    ).user;
    if(firebaseUser!=null)
      {
        print("USER'S ID -> "+firebaseUser.uid);
        await FirestoreService().createUserProfile(name,email,phoneNo,ctx,firebaseUser.uid );
        Navigator.pushNamedAndRemoveUntil(ctx, MainScreen.idScreen, (route) => false,arguments: {"userID":firebaseUser.uid});
      }
    else
      {
        print("Error Signing in ");
        Fluttertoast.showToast(msg: "User Not Found!");
      }
  }
  //Sign Up with email and password
  SignInWithEmailPassword(String email,String password,String name,String phoneNo,BuildContext context,String idScreen)
  {
    ctx = context;
    try
    {
      if(idScreen == "Login")
      {
        signInWithEmailPassword(email, password);
      }
      else if(idScreen == "Register")
        {
          CreateUserWithEmailPassword(email, password,name,phoneNo);
        }
    }
    catch(e)
    {
      print("ERROR!! "+e.toString());
      Fluttertoast.showToast(msg: "Error in auth :- "+e.toString());
      Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.idScreen, (route) => false);
    }


  }
  Future wait() async
  {
    await Future.delayed(const Duration(seconds: 2), (){});
  }
}

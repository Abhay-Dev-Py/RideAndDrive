import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:production_app/AllScreens/mainScreen.dart';
import 'package:production_app/DataHandler/appData.dart';
import 'package:production_app/Models/address.dart';
import 'package:production_app/PythonApi/Python&App.dart';
import 'package:provider/provider.dart';
class FirestoreService
{
  final fireStoreInstance = FirebaseFirestore.instance;
  String userId;
  //Create user in the directory
  Future createUserProfile(String name,String email,String phoneNo, BuildContext context,String uid) async
  {
    print("Flag 1");
    try
    {
      print("Uniquie ID!! "+uid);
      userId = uid;
      await fireStoreInstance.collection('users').doc(uid.toString()).collection('userInfo').doc(uid.toString()).set
        (
          {
            'name' : name,
            'email' : email,
            'phoneNo' : phoneNo
          }
      ).then((value)
      {
        print("UUUIIIDDD ->"+userId);
        Future<Map> userData = readUserProfile(userId);
        print("IN FirestoreFuntion userdata-- "+userData.toString());
        Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false,arguments: {"userID":userId});
      });
    }
    catch(e)
    {
      print("Error msg "+e.toString());
      Fluttertoast.showToast(msg : "Error "+e.toString());
    }

    print("Flag 2");
  }
  //Function to get user details from userID
  Future<Map> readUserProfile(String userID) async
  {

    Map userData;
    await fireStoreInstance.collection("users").doc(userID).collection('userInfo').doc(userID).get().then((value)
    {
      print(value.data());
      userData = value.data();
      print("Value of userData "+userData.toString());
      return userData;
    }
    );

  }
  //Function to store the current location of user
  Future updateCurrentPosition(String uid, double latitude, double longitude,String address,String userClass,String area,BuildContext context) async
  {
    print('Alag userId -> '+uid);

    if(userClass=="rider")
    {
      print('address -> '+address);
      //Save Current Location In Rider's Collection!!
      await fireStoreInstance.collection('riders').doc(uid).collection('UsersCurrentLocation').doc(uid).set(
        {
          'address' : address,
          'area' : area,
          'Longitude' : longitude,
          'Latitude' : latitude
        }
      );
      Address userPickupAddress = new Address();

      //userPickupAddress.postalCode = address['postal_code'];
      userPickupAddress.latitude = latitude;
      userPickupAddress.longitude = longitude;
      print('1');
      //userPickupAddress.placeName = Provider.of<AppData>(context).pickUpLocation.placeName;
      print('2');
      //userPickupAddress.placeFormattedAddress = address['address'];
      //Provider.of<AppData>(context,listen: false).updatePickUpLocationAddress(userPickupAddress);
      print('3');
    }
    if(userClass=="driver")
    {
      //Save Current Location In Driver's Collection!!
      //await fireStoreInstance.collection('users').doc(uid).collection('UsersCurrentLocation').doc(uid).set(address);
      Address DriverCurrentAddress = new Address();
    }

  }
  Future setRiderInfo(double lat,double long, String area, String dropOffLocation) async
  {
    await fireStoreInstance.collection('Riders').doc(userId).collection('RidersCurrentLocation').doc(userId).set(
        {
          'DropOffAddress' : dropOffLocation,
          'Longitude' : long,
          'Latitude' : lat,
          'Area' : area
        });


  }

}



//Function to get user details from user object

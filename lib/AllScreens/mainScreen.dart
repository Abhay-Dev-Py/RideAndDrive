import 'dart:async';
//import 'dart:http';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:production_app/AllWidgets/progressDialog.dart';
import 'package:production_app/Assistant/assistantMethods.dart';
import 'package:production_app/DataHandler/appData.dart';
import 'package:production_app/Firestore/FirestoreFunctions.dart';
import 'package:production_app/MachineLearningTools/UserInterface.dart';
import 'package:production_app/Models/address.dart';
import 'package:production_app/Models/directionDetails.dart';
import 'searchScreen.dart';
import 'package:production_app/PythonApi/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:production_app/AllWidgets/Divider.dart';
import 'package:production_app/PythonApi/API.dart';
import 'dart:convert';

import 'package:production_app/PythonApi/Python&App.dart';
import 'package:provider/provider.dart';
class MainScreen extends StatefulWidget {
  static const String idScreen = "Main";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  Position currentPosition;
  double bottomPaddingofMap = 0;
  double searchContainerHeight = 300;
  DirectionDetails tripDirectionDetails;
  Set<Marker> markersSet ={};
  Set<Circle> circlesSet ={};
  double rideDetailsContainerHeight = 0;
  String uid;
  var numberOfRiders = 'Solo Traveller';
  var sliderValue = 1.0;
  IconData iconOfRiders = FontAwesomeIcons.bicycle;
  bool noOfRiderOpen = false;
  List<LatLng> polyLineCoordinates = [];
  Set<Polyline> polyLineSet = {};
  bool drawerOpen = true;
  bool riderOpen = false;
  bool driverOpen = false;
  double requestRideContainerHeight = 0;
  double noOfRiderSelectionHeight = 0;
  String address;
  void makeEntryOfRiderInDataBase() async
  {
    //current location
    //number of riders
    //dropOff Location

  }
  void displayRequestRideContainer()
  {

    setState(() {
      requestRideContainerHeight = 250;
      rideDetailsContainerHeight = 0;
      bottomPaddingofMap = 230;



      drawerOpen = true;
    });
  }
  void displayRideDetailsContainer() async
  {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 240;
      bottomPaddingofMap = 230;
      drawerOpen = false;
    });
  }
  resetApp()
  {
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 300;
      rideDetailsContainerHeight = 0;
      bottomPaddingofMap = 230;
      polyLineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      polyLineCoordinates.clear();

    });
    locatePosition(uid, 'rider');
  }
  Future ReverseGCoding(String lat,String long) async
  {
    return await Python().ReverseGeocoding(lat,long);
  }
  Column rider()
  {
    locatePosition(uid,"rider");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(height: 6,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Text("Hey There", style: TextStyle(fontSize: 12.0)),
                Text("Where to?", style: TextStyle(fontSize: 20.0,fontFamily: "Brand Bold")),
              ],

            ),
            SizedBox(width: 200,),
            Container(
              color: Colors.transparent,
              height: 39,
              width: 50,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    riderOpen = false;
                  });
                },
                child: Icon(
                  Icons.keyboard_backspace_rounded,

                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0,),
        GestureDetector(
          onTap: () async
          {

            var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
            if(res == 'obtainDirection')
              {
                //displayRequestRideContainer();

                displayRideDetailsContainer();
              }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.blueAccent,),
                  SizedBox(width: 10.0,),
                  Text("Search Drop Off"),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 24.0,),
        Row(
          children: [
            Icon(Icons.home, color: Colors.grey,),
            SizedBox(width: 12.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 300,
                        child:Text(
                            Provider.of<AppData>(context).pickUpLocation != null?
                          Provider.of<AppData>(context).pickUpLocation.placeName : "AddHome"


                        )
                    ),
                  ]
                ),
                SizedBox(height: 4.0,),
                Text('Home Address', style: TextStyle(color: Colors.black54,fontSize: 12.0),),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.0,),
        DividerWidget(),
        /*Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon:Icon(Icons.assistant_navigation),

              color: Colors.grey,
              onPressed: ()
              {
                locatePosition(uid,"rider");
              },
            ),
            Text("Get current Location", style:TextStyle(color: Colors.black54,fontSize: 18.0))
          ],
        )*/
      ],
    );
  }
  Column optionScreen()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Center(child: Text("Select your role",
          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: CircleAvatar(
                  backgroundColor: Colors.black,

                  radius: 50,
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: Icon(Icons.person_rounded,size: 45,color: Colors.yellow,),
                          onPressed: ()
                          {

                            setState(() {
                              noOfRiderOpen = true;
                              riderOpen = false;

                            });
                          }
                      ),
                      SizedBox(height: 10,),
                      Text("Rider",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Brand Bold',fontWeight: FontWeight.w800,color: Colors.yellowAccent),),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30,),
              Container(
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 50,
                  child: Column(
                    children: [
                      IconButton(
                          icon: Icon(Icons.taxi_alert,size: 45,color: Colors.yellow,),
                          onPressed: (){
                            locatePosition(uid, 'driver');
                            setState(() {
                              driverOpen = true;
                            });
                          },
                      ),
                      SizedBox(height: 20,),
                      Text("Driver",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Brand Bold',fontWeight: FontWeight.w800,color: Colors.yellow),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Container travelOptions()
  {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 16,
            spreadRadius: 0.5,
            offset: Offset(0.7,0.7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        child: (noOfRiderOpen)?(riderOpen?rider():noOfRiderSelection()):optionScreen(),
      ),
    );
  }
  Column noOfRiderSelection()
  {
    setState(() {
      print('i Am here');
      noOfRiderSelectionHeight = 400;
    });
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '      How many people are there for travelling?',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20,),
        Container(
          child: Align(
            child: Material(
              color: Colors.black,
              elevation: 14,
                borderRadius: BorderRadius.circular(18),
              shadowColor: Color(0x802196F3),
              child: Container(

                width: 300,
                height: 190,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        child: Text(
                          numberOfRiders,
                          style: TextStyle(color: Colors.yellowAccent , fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Container(
                        child: Icon(
                          iconOfRiders,
                          color: Colors.yellow,
                          size: 60,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(6),
                      child:Container(
                        child: Slider(
                          min: 1.0,
                          max: 4.0,
                          divisions: 3,
                          value: sliderValue,
                          activeColor: Colors.pink,
                          inactiveColor: Colors.green,
                          onChanged: (newVal){
                            setState(() {
                              sliderValue = newVal;
                              print('Slider Value ->'+ sliderValue.toString());
                              if(sliderValue == 2)
                                {
                                  iconOfRiders = FontAwesomeIcons.car;
                                  numberOfRiders = 'Two People';
                                }
                              else if(sliderValue == 1)
                              {
                                iconOfRiders = FontAwesomeIcons.biking;
                                numberOfRiders = 'Solo Traveller';
                              }
                              else if(sliderValue == 3)
                              {
                                iconOfRiders = Icons.electric_rickshaw;
                                numberOfRiders = 'Three People';
                              }
                              else if(sliderValue == 4)
                              {
                                iconOfRiders = Icons.directions_car_outlined;
                                numberOfRiders = 'Four People';
                              }
                            });
                          },
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),

          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),

                ),
                color: Colors.black,
                child: Text(
                  'Confirm Riders',
                  style: TextStyle(color: Colors.yellow),
                ),
                onPressed: (){
                  print('Clicked!');
                  setState(() {
                    noOfRiderSelectionHeight = 0;
                    riderOpen = true;

                  });
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                color: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),

                ),
                child : Icon(Icons.keyboard_backspace_rounded,color: Colors.yellowAccent,),
                onPressed: (){
                  setState(() {
                    noOfRiderOpen = false;
                    noOfRiderSelectionHeight = 0;
                  });
                },

              ),
            ),
          ),
        ),
      ],
    );
  }

  void locatePosition(String uid,String userType) async
  {
    Position position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(22.344111, 73.189861);
    //LatLng latLngPosition = LatLng(position.latitude,position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    //var address = await ReverseGCoding(position.latitude.toString(),position.longitude.toString());
    /*Map address = await ReverseGCoding("22.344089", "73.189856");*/


    address = await AssistantMethods().searchCoordinateAddress(position,context);
    String area = Provider.of<AppData>(context).pickUpLocation != null?
    Provider.of<AppData>(context).pickUpLocation.area : null;
    //await FirestoreService().updateCurrentPosition(uid,position.latitude,position.longitude,address,userType,context);
    //await FirestoreService().updateCurrentPosition(uid,22.344111, 73.189861,address,userType,context);
    updateUsersDetail(address, uid, area, userType);
    print("ADDRESS FROM ASSISTANT -> "+address);
  }
  void updateUsersDetail(String address, String uid, String area,String userType) async
  {
    await FirestoreService().updateCurrentPosition(uid,22.344111, 73.189861,address,userType,area,context);

  }
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.345110, 73.188600),
    zoom: 14.4746,
  );
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    //Map arguments = ModalRoute.of(context).settings.arguments as Map;
    //uid = arguments['userID'];

    return Scaffold(
      key:scaffoldKey,
      appBar: AppBar(
        title: Text('Ride And Drive',style: TextStyle(color: Colors.yellow),),
        backgroundColor: Colors.black,
        elevation: 10,

      ),
      drawer: Container(
        color: Colors.yellow,
        width: 255.0,
        child: Drawer(

          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png",height: 64.0, width: 64.0,),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Profile Name", style: TextStyle(fontSize: 16,fontFamily: "Brand Bold"),),
                          SizedBox(height: 6.0,),
                          Text("Visit Profile"),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              DividerWidget(),
              SizedBox(height: 12.0,),
              //Drawer Body
              ListTile(
                leading: Icon(Icons.history),
                title: Text("History",style: TextStyle(fontSize: 15),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit Profile",style: TextStyle(fontSize: 15),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About",style: TextStyle(fontSize: 15),),
              ),

            ],
          ),
        ),
      ),
      body:(driverOpen)?MyApp2(): Stack(
        children: [
          GoogleMap(

            padding: EdgeInsets.only(bottom: bottomPaddingofMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller)
            {

              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingofMap = 300.0;
              });

            },

          ),
          //HamburgerButton
          Positioned(
            top: 38.0,
            left: 22.0,
            child: GestureDetector(
              onTap: (){
                if(drawerOpen)
                  {
                    scaffoldKey.currentState.openDrawer();

                  }
                else{
                  resetApp();
                }

              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon((drawerOpen)?Icons.menu:Icons.close,color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: (noOfRiderSelectionHeight == 0)?searchContainerHeight:noOfRiderSelectionHeight,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: (noOfRiderOpen)?(riderOpen?rider():noOfRiderSelection()):optionScreen(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,

            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),

                    ),
                  ],
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 17),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.yellow,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Image.asset('images/taxi.png',height: 70,width: 80,),
                              SizedBox(width: 16,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Vehicle",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Brand-Bold'
                                    ),

                                  ),
                                  Text(
                                    ((tripDirectionDetails!= null) ? tripDirectionDetails.distanceText : ''),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Brand-Bold'
                                    ),

                                  ),
                                  ],
                              ),
                              Expanded(
                                child: Container(

                                ),
                              ),
                              Text(
                                ((tripDirectionDetails != null) ? "${AssistantMethods.calculateFare(tripDirectionDetails)}₹": ''),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Brand-Bold',
                                    color: Colors.black
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.moneyCheck,size: 18,color: Colors.black54,),
                            SizedBox(width: 16,),
                            Text('Cash'),
                            SizedBox(
                              width: 6.0,
                            ),
                            Icon(Icons.keyboard_arrow_down,color: Colors.black54,size: 16),


                          ],
                        ),
                      ),
                      SizedBox(height: 24,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: RaisedButton(
                          onPressed: (){
                            displayRequestRideContainer();
                          },
                          color: Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Request",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.yellow),),
                                Icon(FontAwesomeIcons.taxi,color: Colors.yellow,size: 26,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                  spreadRadius: 0.5,
                    blurRadius: 16,
                    color: Colors.black54,
                    offset: Offset(0.7,0.7)
                  ),
                  ]
              ),
              height: requestRideContainerHeight,
              child: Padding(
                padding:  EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    SizedBox(height: 12,),
                    SizedBox(
                      width: double.infinity,
                      child: ColorizeAnimatedTextKit(
                        onTap: ()
                          {
                            print('Tap Event');
                          },
                          text:['Requesting a ride','Please wait...','Finding a driver'],
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontSize: 55,
                          fontFamily: 'Signatra'
                        ),
                        colors: [Colors.green,Colors.pink,Colors.purple,Colors.blue,Colors.yellow,Colors.red],

                      ),
                    ),
                    SizedBox(height: 22,),
                    GestureDetector(
                      onTap: (){
                        requestRideContainerHeight =0;
                        resetApp();
                      },

                      child:Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(width: 2,color: Colors.grey[400])

                      ),
                      child: Icon(Icons.close,size: 26,),
                    ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                        width: double.infinity,
                        child: Text('Cancel Ride',textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),

                      ),




                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: (driverOpen)?FloatingActionButton(
        onPressed: (){
          setState(() {
            driverOpen = false;
          });

        },
        backgroundColor: Colors.black,
        child: Icon(
          Icons.arrow_back_rounded,
          color: Colors.yellowAccent,
        ),
      ):null,
    );
  }

  Future<void> getPlaceDirection() async
  {
    var initialPos = Provider.of<AppData>(context,listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context,listen: false).dropOffLocation;
    //var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var pickUpLatLng = LatLng(22.344108, 73.189854);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(msg: "Please wait...",)
    );
    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
    setState(() {
      tripDirectionDetails = details;
    });
    Navigator.pop(context);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);
    polyLineCoordinates.clear();
    if(decodedPolyLinePointsResult.isNotEmpty)
      {
        decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng)
        {
          polyLineCoordinates.add(LatLng(pointLatLng.latitude,pointLatLng.longitude));

        });
      }
    polyLineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color : Colors.pinkAccent,
        polylineId: PolylineId('PolyLineID'),
        jointType: JointType.round,
        points: polyLineCoordinates,
        width: 5,
        startCap : Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polyLineSet.add(polyline);
      print('in set state');
    });
    LatLngBounds latLngBounds;
    if(pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude)
      {
        latLngBounds = LatLngBounds(southwest: dropOffLatLng,northeast: pickUpLatLng);
      }
    else if(pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    }
    else if(pickUpLatLng.latitude > dropOffLatLng.latitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    }
    else
      {
        latLngBounds = LatLngBounds(southwest: pickUpLatLng,northeast: dropOffLatLng);
      }
    newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
    Marker pickUpLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(title: initialPos.placeName,snippet: 'My Location'),
      position: pickUpLatLng,
      markerId: MarkerId('PickUpID'),
    );
    Marker dropOffLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      infoWindow: InfoWindow(title: finalPos.placeName,snippet: 'dropOff Location'),
      position: dropOffLatLng,
      markerId: MarkerId('dropOffID'),
    );
    setState(() {
      markersSet.add(pickUpLocationMarker);
      markersSet.add(dropOffLocationMarker);
    });
    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.yellowAccent,
      circleId: CircleId('PickUpID'),
    );
    Circle dropOffLocCircle = Circle(
      fillColor: Colors.red,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId('DropOffID'),
    );
    setState(() {
      print(pickUpLatLng.latitude.toString()+ " -> " +pickUpLatLng.longitude.toString());
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }
}

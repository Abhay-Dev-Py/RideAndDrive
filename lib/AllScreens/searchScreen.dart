
import 'package:flutter/material.dart';
import 'package:production_app/AllWidgets/Divider.dart';
import 'package:production_app/AllWidgets/progressDialog.dart';
import 'package:production_app/Assistant/requestAssistant.dart';
import 'package:production_app/DataHandler/appData.dart';
import 'package:production_app/Models/address.dart';
import 'package:production_app/Models/placePredictions.dart';
import 'package:production_app/configMaps.dart';
import 'package:provider/provider.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList =[] ;
  @override
  Widget build(BuildContext context) {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;
    //String dropOffAddress = Provider.of<AppData>(context).dropOffLocation.placeName ?? "";
    //dropOffTextEditingController.text = dropOffAddress;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 185,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7)
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25 , top: 25, right: 25, bottom: 20),
              child: Column(
                children: [
                  SizedBox(height: 5.0,),
                  Stack(
                    children: [
                      GestureDetector(
                          child: Icon(Icons.arrow_back),
                        onTap: (){Navigator.pop(context);},
                      ),
                      Center(
                        child: Text("Set Drop Off",style: TextStyle(fontSize: 18,fontFamily: "Brand-Bold"),),
                      ),

                    ],

                  ),
                  SizedBox(height: 16,),
                  Row(
                    children: [
                      Image.asset("images/pickicon.png",height: 16,width: 16,),
                      SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                  hintText: "Pickup Location",
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11,top: 8,bottom: 8)
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Image.asset("images/desticon.png",height: 16,width: 16,),
                      SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: TextField(
                              onChanged: (val)
                              {
                                findPlace(val);
                              },
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                  hintText: "DropOff Location",
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11,top: 8,bottom: 8)
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          (placePredictionList.length > 0) ?
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
            child: ListView.separated(
                padding: EdgeInsets.all(0),
                itemBuilder: (context, index)
                {
                  return PredictionTile(placePredictions: placePredictionList[index],);
                },
                separatorBuilder: (BuildContext context, int index)=>DividerWidget(),
                itemCount: placePredictionList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          ) :
          Container()
        ],
      ),
    );
  }

  void findPlace(String placeName) async
  {
    if(placeName.length >= 1)
      {
        String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:in";

        var response = await RequestAssistant.getRequest(autoCompleteUrl);
        if(response == 'failed')
          {
            return;
          }
        if(response['status'] == 'OK')
          {
            var predictions = response['predictions'];
            var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
            setState(() {
              placePredictionList = placesList;
            });
          }
      }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;
  PredictionTile({Key key,this.placePredictions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: ()
      {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10,),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          placePredictions.main_text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14)
                      ),
                      SizedBox(height: 2,),
                      Text(
                        placePredictions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16,color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,)
          ],
        ),
      ),
    );
  }
  void getPlaceAddressDetails(String placeId,context) async
  {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(msg: "Please wait....",)
    );
    String placeDetailUrl = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey';

    var response = await RequestAssistant.getRequest(placeDetailUrl);
    Navigator.pop(context);
    if(response == 'failed')
      {
        return;
      }
    if(response['status'] == 'OK')
      {
        Address address = Address();
        address.placeName = response['result']['name'];
        address.placeId = placeId;
        address.latitude = response['result']['geometry']['location']['lat'];
        address.longitude = response['result']['geometry']['location']['lng'];
        Provider.of<AppData>(context,listen: false).updateDropOffLocationAddress(address);
        print("This is drop off location -> "+ address.placeName);
        Navigator.pop(context, "obtainDirection");
      }

  }
}

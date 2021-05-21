import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:production_app/Assistant/requestAssistant.dart';
import 'package:production_app/DataHandler/appData.dart';
import 'package:production_app/Models/address.dart';
import 'package:production_app/Models/directionDetails.dart';
import 'package:production_app/configMaps.dart';
import 'package:provider/provider.dart';

class AssistantMethods
{
  //Perform geocoding request
  Future<String> searchCoordinateAddress(Position position, context) async
  {
    String  placeAddress;
    String st1,st2,st3,st4,st0,st01;

    //String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=22.344105,73.189864&key=${mapKey}";
    var response = await RequestAssistant.getRequest(url);
    if(response!='failed')
      {

        //placeAddress = response['results'][0]['formatted_address'];
        st0 = response['results'][0]['address_components'][0]['long_name'];
        st01 = response['results'][0]['address_components'][3]['long_name'];
        st1 = response['results'][0]['address_components'][3]['long_name'];
        st2 = response['results'][0]['address_components'][4]['long_name'];
        st3 = response['results'][0]['address_components'][5]['long_name'];
        //st4 = response['results'][0]['address_components'][6]['long_name'];
        placeAddress = st1+", "+st2+", "+st3+", ";

        Address userPickUpAddress = new Address();
        userPickUpAddress.longitude = position.longitude;
        userPickUpAddress.latitude = position.latitude;
        userPickUpAddress.placeName = placeAddress;
        userPickUpAddress.area = st2;
        Provider.of<AppData>(context,listen: false).updatePickUpLocationAddress(userPickUpAddress);

      }
    return placeAddress;
  }
  static Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition,LatLng finalPosition) async
  {
    print('b');

    //String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude.toString()},${initialPosition.longitude.toString()}&destination=${finalPosition.latitude},${finalPosition.longitude}&mode=driving&key=$mapKey";
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=22.344105,73.189864&destination=${finalPosition.latitude},${finalPosition.longitude}&mode=driving&key=$mapKey";
    //String directionUrl = "www.google.com";
    print('DirectionURL -> '+directionUrl);
    var res = await RequestAssistant.getRequest(directionUrl);
    if(res == 'failed')
      {
        return null;
      }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints = res['routes'][0]['overview_polyline']['points'];
    directionDetails.distanceText = res['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue = res['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.durationText = res['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue = res['routes'][0]['legs'][0]['duration']['value'];
    return directionDetails;

  }
  static double perKmCharges(String VehicleType)
  {
    double priceOfFuel;
    double averageOfVehicle;
    double perKmCost;
    if(VehicleType == '2-wheeler')
      {
        //Petrol cost in india
        priceOfFuel = 93.1;
        averageOfVehicle = 60;
        perKmCost = priceOfFuel/averageOfVehicle;
        return perKmCost;
      }
    if(VehicleType == '4-wheeler')
    {
      //Petrol cost in india
      priceOfFuel = 93.1;
      averageOfVehicle = 60;
      perKmCost = priceOfFuel/averageOfVehicle;
      return perKmCost;
    }
  }
  static int calculateFare(DirectionDetails directionDetails)
  {

    //Per Min charges in rupees
    double timeTraveledFare = (directionDetails.durationValue / 60) * 3;
    //Per Km charges in rupees
    double distanceTraveledFare = (directionDetails.distanceValue / 1000) * 5;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;
    return totalFareAmount.truncate();
  }
}
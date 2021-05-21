import 'package:production_app/PythonApi/API.dart';
import 'dart:convert';
class Python
{
  String url = 'http://10.0.2.2:5000/dataFromApp?';
  var Data;
  Map address = null;

  ReverseGeocoding(String latitude,String longitude) async
  {
    url = url + "lat="+latitude+"&long="+longitude;
    Data = await getData(url);
    var DecodedData = jsonDecode(Data);
    address = DecodedData['address'];
    return address;
  }
}
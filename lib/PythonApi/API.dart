import 'package:http/http.dart' as http;
Future getData(url) async
{
  http.Response Response = await http.get(url);
  //print("Expected Response -> "+Response.body);
  return Response.body;
}

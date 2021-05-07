import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:online_class_schedule/src/utils/utils.dart';

Future<Map> getJsonClassData() async {
  http.Response response = await http.get(Uri.parse(apiUrl));
  return json.decode(response.body);
}
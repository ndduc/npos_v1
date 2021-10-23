import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:npos/Model/user.dart';

class UserService {
  static String _url = 'https://9i2y5cnuv1.execute-api.us-west-1.amazonaws.com/Prod/';
  static Future browse() async {
    print("TEST HERE");
    List collection;
    // ignore: deprecated_member_use
    List<User>? _contacts;
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      print("200");
      collection = convert.jsonDecode(response.body);
      print(collection.length);
      _contacts = collection.map((json) => User.fromJson(json)).toList();
    } else {
      print("fail");
      print('Request failed with status: ${response.statusCode}.');
    }

    return _contacts;
  }
}

//https://dev.to/offlineprogrammer/flutter-getting-started-with-the-bloc-pattern-streams-http-request-response-1mo3
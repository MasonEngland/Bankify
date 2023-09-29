import "dart:convert";

import "package:http/http.dart" as http;

String? token;

Future getData() async {
  Uri url = Uri.parse("http://localhost:1156/Auth/Login");

  var headers = {
    "Accept": "application/json",
    "content-type": "application/json",
  };
  String body = jsonEncode({
    "Username": "Mason",
    "Password": "notPassword",
    "Email": "masonengland01@gmail.com"
  });

  var response = await http.post(url, body: body, headers: headers);
  token = jsonDecode(response.body)["token"];
  return token;
}

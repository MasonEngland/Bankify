import "dart:convert";
import "package:http/http.dart" as http;
import "dart:developer";

class FetchHandler {
  static Uri url = Uri.parse("http://localhost:1156/Auth/Login");
  static Map<String, dynamic>? userData;
  static String? token;

  static Future<bool> sendLogin(Map<String, dynamic> data) async {
    const headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    String body = jsonEncode(data);

    var response = await http.post(url, body: body, headers: headers);

    log(response.statusCode as String);

    if (response.statusCode != 200) {
      return false;
    }
    userData = jsonDecode(response.body);
    return true;
  }
}

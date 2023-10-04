import "dart:convert";
import "package:http/http.dart" as http;

class FetchHandler {
  static Map<String, dynamic>? userData;
  static String? token;

  static Future<bool> sendLogin(Map<String, dynamic> data) async {
    Uri url = Uri.parse("http://localhost:1156/Auth/Login");
    const headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    String body = jsonEncode(data);
    var response = await http.post(url, body: body, headers: headers);
    print(response.statusCode.toString());
    if (response.statusCode != 200) {
      return false;
    }
    userData = jsonDecode(response.body);
    return true;
  }

  static Future<bool> sendRegister(Map<String, dynamic> data) async {
    Uri url = Uri.parse("http://localhost:1156/Auth/Register");
    String body = jsonEncode(data);
    const headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    http.Response response = await http.post(url, body: body, headers: headers);
    print(response.statusCode.toString());
    if (response.statusCode != 200 && response.statusCode != 201) {
      return false;
    }
    return true;
  }
}

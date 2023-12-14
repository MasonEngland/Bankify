// ignore_for_file: avoid_print
import "dart:convert";
import "dart:developer";
import "package:http/http.dart" as http;

class FetchHandler {
  static Map<String, dynamic>? userData;
  static String? token;
  static String? id;

  static Future<bool> sendLogin(Map<String, dynamic> data) async {
    Uri url = Uri.parse("http://localhost:1156/Auth/Login");
    const headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    String body = jsonEncode(data);

    try {
      var response = await http.post(url, body: body, headers: headers);
      if (response.statusCode != 200) {
        return false;
      }
      userData = jsonDecode(response.body);
      if (userData == null) {
        return false;
      }
      token = userData?["token"];
      id = userData?["id"];
      return true;
    } catch (err) {
      //print(err.toString());
      return false;
    }
  }

  static Future<bool> sendRegister(Map<String, dynamic> data) async {
    Uri url = Uri.parse("http://localhost:1156/Auth/Register");
    String body = jsonEncode(data);
    const headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    try {
      http.Response response = await http.post(
        url,
        body: body,
        headers: headers,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        return false;
      }
      return true;
    } catch (err) {
      log(err.toString());
      return false;
    }
  }

  static Future<List<dynamic>> getAccounts() async {
    Uri url = Uri.parse("http://localhost:1156/Bank/GetAll");

    var headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "authorization": "bearer $token"
    };

    http.Response data = await http.get(url, headers: headers);
    List<dynamic> body = jsonDecode(data.body);

    if (data.statusCode != 201 && data.statusCode != 200) {
      print("failed");
      return [
        {"failed": true}
      ];
    }
    return body;
  }

  static Future<Map?> sendMoney(
    String accountId,
    double balance,
    String description,
  ) async {
    if (balance < 0) {
      return null;
    }

    List<dynamic> accounts = await getAccounts();
    String accountFrom = "";
    for (var item in accounts) {
      if (item["name"] == "MyStyle Checking") {
        accountFrom = item["id"];
      }
    }

    Map body = {
      "accountFrom": accountFrom,
      "Balance": balance,
      "Description": description
    };

    Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "authorization": "bearer $token"
    };

    Uri url = Uri.parse("http://localhost:1156/Bank/Balance/$accountId");

    http.Response response =
        await http.patch(url, headers: headers, body: body);

    if (response.statusCode != 200 || response.statusCode != 201) {
      return null;
    }

    Map<String, dynamic> resBody = jsonDecode(response.body);

    return resBody;
  }
}

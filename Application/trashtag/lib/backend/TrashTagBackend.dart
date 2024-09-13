import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trashtag/globalvariables.dart';

class ResponseType<T> {
  T result;
  String message;

  ResponseType({
    required this.result,
    required this.message,
  });
}

class TrashTagBackend {
  Future<ResponseType<void>> addDustbin(
      {required String name,
      required String type,
      required Map<String, dynamic> location}) async {
    final res = await http.post(Uri.parse("$url/ecoperks/add_dustbin"),
        body: jsonEncode({"name": name, "type": type, "location": location}));
    if (res.statusCode == 200) {
      return ResponseType(result: true, message: res.body);
    }
    print('ERROR => ${res.body}');
    return ResponseType(result: false, message: res.body);
  }

  Future<ResponseType<bool>> register(
      {required String name,
      required String username,
      required String password}) async {
    final res = await http.post(
      Uri.parse("$url/user/register"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          {'name': name, 'username': username, 'password': password}),
    );
    if (res.statusCode == 200) {
      return ResponseType(result: true, message: 'success');
    }
    print('ERROR => ${res.body}');
    return ResponseType(result: true, message: res.body.toString());
  }

  Future<ResponseType<bool>> login(
      {required String username, required String password}) async {
    final res = await http.post(
      Uri.parse("$url/user/login"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {'username': username, 'password': password},
      ),
    );
    if (res.statusCode == 200) {
      final resdata = jsonDecode(res.body);
      final succ = resdata['success'] ?? false;
      if (succ) {
        return ResponseType(result: true, message: 'success');
      } else {
        print("ERROR ===> ${resdata['message']}");
        return ResponseType(result: false, message: resdata['message']);
      }
    }
    print('ERROR => ${res.body}');
    return ResponseType(result: false, message: res.body);
  }
}

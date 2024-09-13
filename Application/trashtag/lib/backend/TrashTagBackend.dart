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
}

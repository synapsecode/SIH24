import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:trashtag/globalvariables.dart';
import 'package:trashtag/models/user.dart';

import '../models/dustbin.dart';

class ResponseType<T> {
  T result;
  String message;

  ResponseType({
    required this.result,
    required this.message,
  });
}

class TrashTagBackend {
  Future<ResponseType<bool>> addDustbin(
      {required String name,
      required String type,
      required LatLng location}) async {
    final jsonloc = {'lat': location.latitude, 'lng': location.longitude};
    print(jsonEncode({"name": name, "type": type, "location": jsonloc}));
    final res = await http.post(Uri.parse("$url/ecoperks/add_dustbin"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "type": type, "location": jsonloc}));
    if (res.statusCode == 200) {
      return ResponseType(result: true, message: res.body);
    }
    print('ERROR => ${res.body}');
    return ResponseType(result: false, message: res.body);
  }

  Future<ResponseType<bool>> register(
      {required String name,
      required String username,
      required String password,
      required String referrer}) async {
    print(jsonEncode({
      'name': name,
      'username': username,
      'password': password,
      "referrer": referrer.isNotEmpty ? referrer : null
    }));
    final res = await http.post(
      Uri.parse("$url/user/register"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'username': username,
        'password': password,
        "referrer": referrer.isNotEmpty ? referrer : null
      }),
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

  Future<ResponseType<int?>> getUserID({required String username}) async {
    final res =
        await http.get(Uri.parse('$url/user/get_id_by_username/$username'));

    if (res.statusCode == 200) {
      final resbody = jsonDecode(res.body);
      final id = int.parse(resbody['id'].toString());
      return ResponseType(result: id, message: 'success');
    }
    return ResponseType(result: null, message: res.body);
  }

  Future<ResponseType<double?>> getUserPoints({required int userID}) async {
    final res = await http.get(Uri.parse('$url/user/get_user_points/$userID'));
    if (res.statusCode == 200) {
      final resbody = jsonDecode(res.body);
      final id = double.parse(resbody['points'].toString());
      return ResponseType(result: id, message: 'success');
    }
    return ResponseType(result: null, message: res.body);
  }

  Future<ResponseType<bool>> add2dustbin(
      {required int userId,
      required String productqr,
      required String binqr}) async {
    final res = await http.post(
      Uri.parse('$url/ecoperks/userscan'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {'uid': userId, 'productcode': productqr, 'dustbincode': binqr},
      ),
    );
    if (res.statusCode == 200) {
      return ResponseType(result: true, message: res.body);
    }
    print('ERROR => ${res.body}');
    return ResponseType(result: false, message: res.body);
  }

  Future<ResponseType<List<Dustbin>?>> getAllBins() async {
    List<Dustbin> dustbins = [];
    final res = await http.get(Uri.parse("$url/binocculars/get_all"));

    if (res.statusCode == 200) {
      final resdata = jsonDecode(res.body);
      for (final r in resdata) {
        final d = Dustbin.fromJson(r);
        dustbins.add(d);
      }
    } else {
      return ResponseType(
        result: null,
        message: 'Server Side Error (${res.statusCode})',
      );
    }
    return ResponseType(result: dustbins, message: 'success');
  }

  Future<ResponseType<List<Dustbin>?>> getNearestBins({
    required double lat,
    required double lng,
    required double radius,
  }) async {
    List<Dustbin> dustbins = [];
    final uri = Uri.parse("$url/binocculars/get_proximal/$lat/$lng/$radius");
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final resdata = jsonDecode(res.body);
      for (final x in resdata) {
        final d = Dustbin.fromJson(x);
        dustbins.add(d);
      }
    } else {
      return ResponseType(
        result: null,
        message: 'Server Side Error (${res.statusCode})',
      );
    }
    return ResponseType(result: dustbins, message: 'success');
  }

  Future<ResponseType<List<User>?>> getLeaderboard() async {
    List<User> users = [];
    final res = await http.get(Uri.parse("$url/ecoperks/get_leaderboard"));
    if (res.statusCode == 200) {
      final resdata = jsonDecode(res.body);
      for (final r in resdata) {
        final u = User.fromJson(r);
        users.add(u);
      }
      print(users);
    } else {
      return ResponseType(
          result: null, message: 'Server Side Error (${res.statusCode})');
    }
    return ResponseType(result: users, message: 'success');
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:trashtag/backend/TrashTagBackend.dart';
import 'package:trashtag/models/user.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  List<User>? users;
  Timer? _timer;
  User? currentUser;
  int? rank;

  final tileColor = {
    0: Color.fromARGB(255, 6, 63, 41),
    1: Color.fromARGB(255, 3, 81, 51),
    2: Color.fromARGB(255, 4, 96, 61),
  };

  final trophy = {
    0: 'assets/trophy-star.png',
    1: 'assets/winner.png',
    2: 'assets/trophy.png',
  };

  Color getColor(int index) {
    return tileColor[index] ?? Color.fromARGB(255, 7, 121, 77);
  }

  loadLeaderboard() async {
    print('fetching...');

    final r = await TrashTagBackend().getLeaderboard();

    if (r.result != null) {
      final prefs = await SharedPreferences.getInstance();
      final uname = prefs.getString('x-user');
      // print(r);
      setState(() {
        users = r.result;
        currentUser = users!.firstWhere((element) => element.username == uname);
        rank = users!.indexOf(currentUser!) + 1;
      });
    } else {
      ToastContext().init(context);
      Toast.show(r.message);
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      loadLeaderboard();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadLeaderboard();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 158, 222, 233),

      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Leaderboard 🏆',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                // fontStyle: FontStyle.italic
              ),
            ),
            Text(
              'My rank: #$rank (${currentUser?.points})',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            users == null
                ? Text('No users')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: users!.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Card(
                        color: getColor(index),
                        child: ListTile(
                          leading: Text(
                            '#${index + 1}',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          title: Text(
                            users![index].username,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          subtitle: Text(
                            'Points: ${users![index].points}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          trailing: (index == 0 || index == 1 || index == 2)
                              ? Image.asset(trophy[index]!)
                              : SizedBox.shrink(),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //     onPressed: () {}, label: Text('My rank: #$rank')),
    );
  }
}

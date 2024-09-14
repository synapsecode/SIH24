import 'dart:async';

import 'package:flutter/material.dart';
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

  loadLeaderboard() async {
    print('fetching...');
    final r = await TrashTagBackend().getLeaderboard();
    if (r.result != null) {
      // print(r);
      setState(() {
        users = r.result;
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
      body: Center(
          child: Column(children: [
        Text('Leaderboard'),
        users == null
            ? Text('No users')
            : ListView.builder(
                shrinkWrap: true,
                itemCount: users!.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return Card(
                    child: ListTile(
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(fontSize: 18),
                      ),
                      title: Text(
                        users![index].username,
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        'Points: ${users![index].points}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                })
      ])),
    );
  }
}

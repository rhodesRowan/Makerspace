import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:firebase_practise/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  @override
  State createState() => TimerState();
}

class TimerState extends State<TimerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text("Tasks"),
        ),
        body: buildTime()
        );
  }

  Widget buildTime() {
    final CustomTimerController _controller = new CustomTimerController();
    final Firestore_Service _firestore = Firestore_Service();

    return Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("Start"),
                  onPressed: () => _controller.start(),
                ),
                ElevatedButton(
                  child: Text("Pause"),
                  onPressed: () => _controller.pause(),
                ),
                ElevatedButton(
                  child: Text("Reset"),
                  onPressed: () => _controller.reset(),
                ),
              ],
            ),
            SizedBox(height: 16),
            CustomTimer(
              controller: _controller,
              from: Duration(minutes: 25),
              to: Duration(hours: 0),
              builder: (CustomTimerRemainingTime remaining) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTimeCard(time: "${remaining.minutes}", header: "MINUTES"),
                    SizedBox(width: 10),
                    buildTimeCard(time: "${remaining.seconds}", header: "SECONDS")
                  ],
                );
              },
            ),
            SizedBox(height: 16.0,),
          ListTile(
            title: Text("My Tasks", style: TextStyle(fontSize: 20)),
            trailing: IconButton(icon: Icon(Icons.filter_list),),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.getPostsStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading...");
              }
              return ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data();
                    return ListTile(
                      title: Text(data["post"]),
                      // trailing: Text(
                      //   readTimestamp(DateTime.fromMillisecondsSinceEpoch(data["createdAt"]).millisecondsSinceEpoch)
                      // ),
                    );
                  }).toList());
            },
          ),
        ]));
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  Widget buildTimeCard({@required String time, @required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(20)),
          child: Text(
            time,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 72),
          ),
        ),
        const SizedBox(height: 16),
        Text(header)
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:convert';
import 'PlayScreen.dart';
// import 'package:flutter/services.dart';

final userswaiting =
ValueNotifier<List<User>>(new List<User>());

class WaitingScreen extends StatefulWidget {
  @override
  _WaitingScreen createState() => _WaitingScreen();
}

class _WaitingScreen extends State<WaitingScreen> {
  List<Widget> listwaitinguser(List<User> lu) {
    List<Widget> lw = new List<Widget>();
    for (int a = 0; a < lu.length; a++) {
      lw.add(
        Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            child: AspectRatio(
              aspectRatio: 4 / 1,
              child: Card(
                color: colors[lu[a].color],
                child: Center(
                  child: Text(lu[a].id.toString(),
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            )),
      );
    }
    return lw;
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.bottom]);
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          image: DecorationImage(
            // colorFilter: new ColorFilter.mode(
            //     Colors.white60.withOpacity(0.9), BlendMode.dstATop),
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.fitHeight,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(top: 30),
                child:
                ValueListenableBuilder<List<User>>(
                  valueListenable: userswaiting,
                  builder: (context, value, widget) {
                    // print("thay doi "+value.toString());
                    return
                      Column(
                        children: value==null ? [] : listwaitinguser(value),
                      );
                  },
                ),
              ),
            ),
            ValueListenableBuilder<ClientStatus>(
              valueListenable: clientstatus,
              builder: (context, value, widget) {
                print(" client load");
                if(value.roomstatus==Roomstatus.Load)
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PlayScreen();
                  }));
                return
                  Container();
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
              child: InkWell(
                onTap: () {
                  udpsocket.send(codec.encode('start|0'), address, port);
                },
                child: AspectRatio(
                  aspectRatio: 4 / 1,
                  child: Card(
                    color: Colors.black,
                    child: Center(
                      child:
                          Text('Start', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}

class User {
  int id;
  int color;
  User({this.id, this.color});
  factory User.FromData(Map<String, dynamic> data) {
    return User(
      id: data['id'] as int,
      color: data['color'] as int,
    );
  }
}

List<User> parseUserList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.FromData(json)).toList();
}

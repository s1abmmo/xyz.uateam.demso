import 'dart:math';
import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

ValueNotifier<List<Number>> listnumber =
    ValueNotifier<List<Number>>(new List<Number>());

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreen createState() => _PlayScreen();
}

class _PlayScreen extends State<PlayScreen> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.bottom]);

    double height = MediaQuery.of(context).size.height;
    height = height - (height * 0.1);
    double width = MediaQuery.of(context).size.width;
    List<Widget> MakeListPositioned(List<Number> lsnumber) {
      List<Widget> listposition = new List<Widget>();
      for (int a = 0; a < lsnumber.length; a++) {
        Positioned newpos = new Positioned(
          top: height * (lsnumber[a].point.y + 5) / 100,
          left: width * (lsnumber[a].point.x + 2) / 100,
          child: InkWell(
            onTap: () {
              if (lsnumber[a].isenable)
                udpsocket.send(
                    codec.encode("numberindex|" + lsnumber[a].id.toString()),
                    address,
                    port);
            },
            child: Container(
              width: height * 0.05,
              height: height * 0.04,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: lsnumber[a].belonguser == -1
                          ? Colors.transparent
                          : colors[lsnumber[a].belonguser])),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text((lsnumber[a].id + 1).toString(),
                    style: TextStyle(
                        fontFamily: 'Apple-Juice-Regular',
                        color: colors[lsnumber[a].color])),
              ),
            ),
          ),
        );
        listposition.add(newpos);
      }
      return listposition;
    }

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
          children: [
            Container(
              width: double.infinity,
              height: height * 0.07,
              child: Row(children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Center(
                    child: Icon(
                      Icons.logout,
                      size: height * 0.05,
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: Center(
                    child: Text(
                      '45',
                      style: TextStyle(fontSize: height * 0.05),
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: ValueListenableBuilder<List<Number>>(
                valueListenable: listnumber,
                builder: (context, value, _) {
                  print("thay doi " + listnumber.value.toString());
                  return Stack(
                    children: value == null ? [] : MakeListPositioned(value),
                  );
                },
              ),
            ),
            // Container(
            //   width: double.infinity,
            //   height: 50.0,
            // ),
          ],
        ),
      ),
    );
  }
}

class Number {
  int id;
  int color;
  Point point;
  bool isenable;
  int belonguser;
  Number({this.id, this.point, this.color, this.belonguser, this.isenable});
  factory Number.FromData(Map<String, dynamic> data) {
    return Number(
        id: data['id'] as int,
        color: data['color'] as int,
        point: new Point(int.parse((data['point'] as String).split(',')[0]),
            int.parse((data['point'] as String).split(',')[1])),
        isenable: false,
        belonguser: -1);
  }
}

List<Number> parseNumberList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Number>((json) => Number.FromData(json)).toList();
}

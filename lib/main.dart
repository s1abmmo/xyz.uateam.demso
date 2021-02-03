import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'WaitingScreen.dart';
import 'PlayScreen.dart';
import 'Join.dart';
import 'ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
// import 'package:flutter/services.dart';
// import 'package:udp/udp.dart';
// import 'dart:async';
// import 'dart:math';
// import 'dart:typed_data';

ValueNotifier<ClientStatus> clientstatus =
    ValueNotifier<ClientStatus>(new ClientStatus());
List colors = [
  Color(0xff003399),
  Color(0xff009999),
  Color(0xff9933cc),
  Color(0xff009933),
  Color(0xff6600cc),
  Color(0xffff33ff),
  Color(0xff000000),
  Color(0xffcc6600),
  Color(0xff33cccc),
  Color(0xff996600)
];

InternetAddress address = new InternetAddress('54.254.4.110');
int port = 8989;
InternetAddress addressesIListenFrom = InternetAddress.anyIPv4;
RawDatagramSocket udpsocket;
Utf8Codec codec = new Utf8Codec();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseAdMob.instance.initialize(appId: AdManager.appId);

  clientstatus.value.ishost = false;
  clientstatus.value.roomstatus = Roomstatus.Wait;
  clientstatus.value.navigated=false;

  print("Connecting to server..");
  // connect(address, port);

  // userswaiting.value = new List<User>(0);
  String status1 = '';
  String status2 = '';
  String status3 = '';

  int portIListenOn = 8989; //0 is random
  RawDatagramSocket.bind(addressesIListenFrom, portIListenOn)
      .then((RawDatagramSocket udpSocket) {
    udpsocket = udpSocket;
    udpSocket.forEach((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram dg = udpSocket.receive();
        String s = new String.fromCharCodes(dg.data);
        List<String> data = s.split('|');
        if (data[0] == '0') {
          if (data[1] != status1) {
            print('update status1');
            status1 = data[1];

            userswaiting.value = parseUserList(data[1]);
            userswaiting.notifyListeners();

            if (clientstatus.value.roomstatus == Roomstatus.Wait) {
              clientstatus.value.roomstatus = Roomstatus.Ready;
              clientstatus.notifyListeners();
            }
          }
        } else if (data[0] == '1') {
          if (data[1] != status2) {
            print('update status2');
            status2 = data[1];
            List<Number> ln = parseNumberList(data[1]);
            if (listnumber.value.length != null &&
                listnumber.value.length != ln.length) {
              listnumber.value = ln;
              listnumber.notifyListeners();
              clientstatus.value.roomstatus = Roomstatus.Load;
              clientstatus.notifyListeners();
            }
          }
        } else if (data[0] == '2') {
          if (data[1] != status3) {
            print('update status3');
            status3 = data[1];
            if (data.length == 2) {
              for (int a = 0; a < listnumber.value.length; a++)
                listnumber.value[a].isenable = false;
              int indexnumber = int.parse(data[1]);
              listnumber.value[indexnumber].isenable = true;
              listnumber.notifyListeners();
            } else if (data.length == 3) {
              print('update status3 3');
              for (int a = 0; a < listnumber.value.length; a++)
                listnumber.value[a].isenable = false;
              int indexnumber = int.parse(data[1]);
              listnumber.value[indexnumber].isenable = true;
              listnumber.value[indexnumber - 1].belonguser = int.parse(data[2]);
              listnumber.notifyListeners();
            }
          }
        }
        print(s);
        // var outputAsUint8List = new Uint8List.fromList(s.codeUnits);
        // dg.data.forEach((x) => print('receive'+x.toString()));
      }
    });
  });

  runApp(MaterialApp(
    home: MainScreen(),
  ));
}


class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

BannerAd _bannerAd;
InterstitialAd myInterstitial;

class _MainScreen extends State<MainScreen> {

  bool stop=true;
  CreateRoom() async {
    print('run');
    if(!stop)
      return;
    await Future.delayed(const Duration(milliseconds: 500), () {
      if (clientstatus.value.roomstatus == Roomstatus.Ready && !clientstatus.value.navigated) {
        if (clientstatus.value.action == ActionRoom.Createroom) {
          clientstatus.value.ishost = true;
          clientstatus.value.navigated=true;
          stop=false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WaitingScreen()),
          ).then((value) => {stop=false,CreateRoom()});
        } else if (clientstatus.value.action == ActionRoom.Join) {
          clientstatus.value.ishost = false;
          clientstatus.value.navigated=true;
          stop=false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WaitingScreen()),
          ).then((value) => {stop=false,CreateRoom()});
        }
      };
    });
    CreateRoom();
  }

  void initState() {
    super.initState();
    CreateRoom();

    myInterstitial=createInterstitialAd();
    myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
      );
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
            fit: BoxFit.fill,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ValueListenableBuilder<ClientStatus>(
            //   valueListenable: clientstatus,
            //   builder: (context, value, widget) {
            //     // print(" client load");
            //     return Container();
            //   },
            // ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
              child: InkWell(
                onTap: () {
                  udpsocket.send(codec.encode('createroom'), address, port);
                  clientstatus.value.action = ActionRoom.Createroom;
                },
                child: AspectRatio(
                  aspectRatio: 4 / 1,
                  child: Card(
                    color: Colors.black,
                    child: Center(
                      child: Text('Create new room',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      barrierDismissible: true,
                      opaque: false,
                      pageBuilder: (_, anim1, anim2) => Join(),
                    ),
                  );
                },
                child: AspectRatio(
                  aspectRatio: 4 / 1,
                  child: Card(
                    color: Colors.black,
                    child: Center(
                      child: Text('Join a room',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientStatus {
  bool ishost;
  bool navigated;
  Roomstatus roomstatus;
  ActionRoom action;
}

enum Roomstatus { Wait, Ready, Load, Play, Finish }

enum ActionRoom { None, Createroom, Join }

import 'package:flutter/material.dart';
import 'WaitingScreen.dart';
import 'main.dart';

class Join extends StatefulWidget {
  final String text;
  Join({Key key, @required this.text}) : super(key: key);
  @override
  _Join createState() => _Join();
}

class _Join extends State<Join> {

  TextEditingController idroomController = new TextEditingController();

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content:
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          // width: MediaQuery.of(context).size.width * 0.8,
          child: AspectRatio(
            aspectRatio: 3 / 2,
                child:
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: width*0.15),
                          child:
                          TextField(
                            controller: idroomController,
                            decoration: InputDecoration(
                              // border: InputBorder.none,
                                hintText: 'Enter id room'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: width*0.15),
                          width: double.infinity,
                          child:
                            AspectRatio(
                              aspectRatio: 3/1,
                              child:
                              InkWell(
                                onTap: (){
                                  udpsocket.send(codec.encode('join|'+idroomController.text), address, port);
                                  clientstatus.value.action=ActionRoom.Join;

                                },
                                child:
                                Card(
                                    color: Colors.red,
                                    child: Center(
                                      child: Text('OK'),
                                    )),
                              ),
                            ),
                        ),
                      ],
                    ),
          ),
        ),
    );
  }
}
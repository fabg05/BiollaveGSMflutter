import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => new _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("DEMO")),
        body: Padding(
            // used padding just for demo purpose to separate from the appbar and the main content
            padding: EdgeInsets.all(10),
            child: Container(
              alignment: Alignment.topCenter,
              child: Container(
                  height: 60,
                  padding: EdgeInsets.all(3.5),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: InkWell(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        topLeft: Radius.circular(12))),
                                child: Text("Referrals",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 17,
                                    )),
                              ))),
                      Expanded(
                          child: InkWell(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                child: Text("Stats",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)),
                              ))),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Container(color: Colors.white, width: 2)),
                      Expanded(
                          child: InkWell(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                child: Text("Edit Profile",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)),
                              )))
                    ],
                  )),
            )));
  }
}

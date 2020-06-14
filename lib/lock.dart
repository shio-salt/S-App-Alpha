import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blue/flutter_blue.dart';

class LockConnectPage extends StatefulWidget {
  final String uid;

  LockConnectPage({Key key, @required this.uid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LockConnectPageState();
}

class _LockConnectPageState extends State<LockConnectPage> {
  final Firestore _firestore = Firestore.instance;
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice _device;
  String uuid = '6E400001-B5A3-F393-E0A9-E50E24DCCA9E';

  String _name = '';
  String _lock = '';


  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  void get() async {
    DocumentSnapshot value =
        await _firestore.collection('users').document(widget.uid).get();
    setState(() {
      _name = value.data['name'];
      _lock = value.data['lock'];
    });
  }

  @override
  void lock() async {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('$_name')),
        body: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Icon(Icons.lock, size: 120.0),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Text('管理キー'),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: 400.0,
                  height: 80.0,
                  padding: EdgeInsets.all(
                    20.0,
                  ),
                  child: FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.perm_device_information),
                    label: Text('機器情報'),
                    color: Colors.blue,
                  )),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: 400.0,
                  height: 80.0,
                  padding: EdgeInsets.all(
                    20.0,
                  ),
                  child: FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.settings),
                    label: Text('機器設定'),
                    color: Colors.blue,
                  )),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: 400.0,
                  height: 80.0,
                  padding: EdgeInsets.all(
                    20.0,
                  ),
                  child: FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.history),
                    label: Text('履歴'),
                    color: Colors.blue,
                  )),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: 400.0,
                  height: 80.0,
                  padding: EdgeInsets.all(
                    20.0,
                  ),
                  child: FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.share),
                    label: Text('共有'),
                    color: Colors.blue,
                  )),
            ),
            Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 40.0, left: 100.0),
                    child: FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: Colors.red,
                        child: Icon(Icons.lock_outline, color: Colors.white))),
                Container(
                    padding: EdgeInsets.only(top: 40.0, left: 80.0),
                    child: FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: Colors.green,
                        child: Icon(Icons.lock_open, color: Colors.white)))
              ],
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_app/lock.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  PageController _pageController;
  int _page = 0;
  String _uid;
  String _title;
  String _displayname = '';
  String _email = '';
  String _name = '';
  String _lock = '';

  @override
  void initState() {
    super.initState();
    get();
    _pageController = PageController(
      initialPage: _page,
    );
    setState(() {
      _title = 'ロック';
    });
  }

  @override
  void get() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    DocumentSnapshot value =
        await _firestore.collection('users').document(user.uid).get();
    setState(() {
      _uid = user.uid;
      _displayname = value.data['displayname'];
      _email = value.data['email'];
      _lock = value.data['lock'];
      _name = value.data['name'];
    });
  }

  @override
  void signout() async {
    await _firebaseAuth.signOut();
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$_title')),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
                height: 180.0,
                child: UserAccountsDrawerHeader(
                    accountName: Text('$_displayname'),
                    accountEmail: Text('$_email'),
                    currentAccountPicture:
                        Icon(Icons.account_circle, size: 80.0),
                    decoration: BoxDecoration())),
            ListTile(
              title: Text('アカウント情報'),
              leading: Icon(Icons.person_outline),
            ),
            ListTile(
              title: Text('設定'),
              leading: Icon(Icons.settings),
            ),
            Divider(),
            ListTile(
              title: Text('アプリ情報'),
              leading: Icon(Icons.info_outline),
            ),
            ListTile(
              title: Text('サポート'),
              leading: Icon(Icons.help_outline),
            ),
            Divider(),
            ListTile(
              title: Text('サインアウト'),
              leading: Icon(Icons.exit_to_app),
              onTap: signout,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.lock), title: Text('ロック')),
            BottomNavigationBarItem(
                icon: Icon(Icons.looks), title: Text('センサー')),
            BottomNavigationBarItem(
                icon: Icon(Icons.device_hub), title: Text('ハブ')),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervisor_account), title: Text('メンバー')),
          ],
          currentIndex: _page,
          onTap: (index) {
            setState(() {
              _page = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.easeOut);
            });
          }),
      body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _page = index;
            });
            switch (_page) {
              case 0:
                setState(() {
                  _title = 'ロック';
                });
                break;
              case 1:
                setState(() {
                  _title = 'センサー';
                });
                break;
              case 2:
                setState(() {
                  _title = 'ハブ';
                });
                break;
              case 3:
                setState(() {
                  _title = 'メンバー';
                });
                break;
              default:
                setState(() {
                  _title = 'エラー';
                });
                break;
            }
          },
          children: [
            LockPage(uid: _uid, name: _name, lock: _lock),
            SensorPage(),
            HubPage(),
            MemberPage()
          ]),
    );
  }
}

class LockPage extends StatelessWidget {
  String uid;
  String lock;
  String name;

  LockPage({Key key,@required this.uid, @required this.lock, @required this.name})
      : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
        body: lock == null
            ? Stack(children: <Widget>[
                Center(child: Text('機器が登録されていません。')),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: FloatingActionButton.extended(
                          onPressed: null,
                          icon: Icon(Icons.add),
                          label: Text('登録'),
                        ))),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Divider(),
                )
              ])
            : ListView(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.school),
                      title: Text('$name'),
                      subtitle: Text('$lock'),
                      onTap: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LockConnectPage(uid: uid),
                          ));}),
                  Divider(),
                  ListTile(),
                  Divider(),
                  ListTile(),
                  Divider(),
                  ListTile(),
                  Divider(),
                  ListTile(),
                  Divider(),
                  ListTile(),
                  Divider(),
                  ListTile(),
                  Divider(),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: FloatingActionButton.extended(
                            onPressed: null,
                            icon: Icon(Icons.add),
                            label: Text('登録'),
                          ))),
                ],
              ));
  }
}

class SensorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('準備中')));
  }
}

class HubPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('準備中')));
  }
}

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('準備中')));
  }
}

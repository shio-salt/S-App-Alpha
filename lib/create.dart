import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => new _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  final _formKey = GlobalKey<FormState>();

  String _displayname;
  String _email;
  String _password;
  String _confirmation;
  String error_message = '';
  bool load = false;

  bool validate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  void create() async {
    if (validate()) {
      if (_password.length == _confirmation.length &&
          _password == _confirmation) {
        load = true;
        try {
          FirebaseUser user =
              (await _firebaseAuth.createUserWithEmailAndPassword(
                      email: _email, password: _password))
                  .user;
          _firestore.collection("users").document(user.uid).setData({
            "uid": user.uid,
            "displayname": _displayname,
            "email": _email,
          });
          user.sendEmailVerification();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyPage(email: _email),
              ));
        } catch (e) {
          switch (e.code) {
            case 'ERROR_WEAK_PASSWORD':
              setState(() {
                error_message = 'パスワードの強度が足りません。';
              });
              break;
            case 'ERROR_INVALID_EMAIL':
              setState(() {
                error_message = '有効なメールアドレスを入力して下さい。';
              });
              break;
            case 'ERROR_EMAIL_ALREADY_IN_USE ':
              setState(() {
                error_message = 'このメールアドレスは既に使用されています。';
              });
              break;
            default:
              setState(() {
                error_message = 'サポートセンターにお問い合わせ下さい。';
              });
          }
        }
      } else {
        setState(() {
          error_message = 'パスワードが一致しません。';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('アカウント作成')),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                       Icon(Icons.person_add, size: 120.0),
                      TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            return value.isEmpty ? '名前を入力して下さい。' : null;
                          },
                          onSaved: (value) {
                            _displayname = value;
                          },
                          decoration: InputDecoration(
                            labelText: '名前',
                            icon: Icon(Icons.person),
                          )),
                      TextFormField(
                          maxLines: 1,
                          validator: (value) {
                            return value.isEmpty ? 'メールアドレスを入力して下さい。' : null;
                          },
                          onSaved: (value) {
                            _email = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'メールアドレス',
                            icon: Icon(Icons.mail_outline),
                          )),
                      TextFormField(
                          maxLines: 1,
                          obscureText: true,
                          validator: (value) {
                            return value.isEmpty ? 'パスワードを入力して下さい。' : null;
                          },
                          onSaved: (value) {
                            _password = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'パスワード',
                            icon: Icon(Icons.lock_outline),
                          )),
                      TextFormField(
                          maxLines: 1,
                          obscureText: true,
                          validator: (value) {
                            return value.isEmpty ? 'パスワードをもう一度入力して下さい。' : null;
                          },
                          onSaved: (value) {
                            _confirmation = value;
                          },
                          decoration: InputDecoration(
                            labelText: '確認',
                            icon: Icon(Icons.lock_outline),
                          )),
                      Container(
                          padding: EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Text('$error_message',
                              style: TextStyle(color: Colors.red))),
                      Container(
                          width: 400.0,
                          height: 60.0,
                          padding: EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: RaisedButton.icon(
                              icon: Icon(Icons.add),
                              label: Text('アカウント作成'),
                              onPressed: create)),
                      showCircularProgress()
                    ])))));
  }

  Widget showCircularProgress() {
    if (load) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}

class VerifyPage extends StatelessWidget {
  final String email;

  VerifyPage({Key key, @required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('')),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(children: <Widget>[
              Icon(Icons.check, size: 120.0),
              Text(
                '認証メールを送信しました。',
                style: TextStyle(fontSize: 27.0),
              ),
              Text('$email' + 'に認証メールを送信しました。\nメールに記載されたURLをクリックして、認証を完了して下さい。',
                  style: TextStyle(fontSize: 13.0)),
              Container(
                  width: 400.0,
                  height: 60.0,
                  padding: EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: RaisedButton.icon(
                      icon: Icon(Icons.arrow_forward),
                      label: Text('サインイン'),
                      onPressed: () {
                        Navigator.pop(context, true);
                      }))
            ])));
  }
}

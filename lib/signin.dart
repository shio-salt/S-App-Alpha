import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:s_app/api.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => new _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String error_message = '';
  bool keep = false;
  bool load = false;

  bool validate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  void checkkeep(bool bool) async {
    setState(() {
      keep = bool;
    });
  }

  void signin() async {
    if (validate()) {
      try {
        setState(() {
          load = true;
        });
        await _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        switch (e.code) {
          case 'ERROR_INVALID_EMAIL':
            setState(() {
              error_message = '有効なメールアドレスを入力して下さい。';
            });
            break;
          case 'ERROR_WRONG_PASSWORD':
            setState(() {
              error_message = 'メールアドレスまたはパスワードが正しくありません。';
            });
            break;
          case 'ERROR_USER_NOT_FOUND':
            setState(() {
              error_message = 'アカウントが存在しません。';
            });
            break;
          case 'ERROR_TOO_MANY_REQUESTS':
            setState(() {
              error_message = 'サインインを制限しました。';
            });
            break;
          default:
            setState(() {
              error_message = 'サポートセンターにお問い合わせ下さい。';
            });
        }
      }
    }
  }

  void signingoogle() async {
    signInWithGoogle().whenComplete(() {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('サインイン')),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Icon(Icons.person, size: 120.0),
                      Container(
                          child: Text('$error_message',
                              style: TextStyle(color: Colors.red))),
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
                      Container(
                          padding: EdgeInsets.only(
                            top: 10.0),
                        child: CheckboxListTile(
                          title: Text('サインインしたままにする'),
                          value: keep,
                          onChanged: checkkeep,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Container(
                          width: 400.0,
                          height: 50.0,
                          padding: EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: RaisedButton.icon(
                              icon: Icon(Icons.arrow_forward),
                              label: Text('サインイン'),
                              onPressed: signin)),
                      Container(
                        width: 400.0,
                        height: 60.0,
                        padding: EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: RaisedButton(
                          onPressed: signingoogle,
                          splashColor: Colors.grey,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                  image: AssetImage("google_logo.png"),
                                  height: 20.0),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Googleでサインイン',
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                          width: 400.0,
                          height: 60.0,
                          padding: EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: FlatButton.icon(
                              icon: Icon(Icons.add),
                              label: Text('アカウント作成'),
                              onPressed: () {
                                Navigator.pushNamed(context, '/create');
                              })),
                      Container(
                          width: 400.0,
                          height: 50.0,
                          padding: EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: FlatButton.icon(
                              icon: Icon(Icons.refresh),
                              label: Text('パスワード再設定'),
                              onPressed: () {
                                Navigator.pushNamed(context, '/reset');
                              })),
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

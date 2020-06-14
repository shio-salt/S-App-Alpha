import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPage extends StatefulWidget {
  @override
  _ResetPageState createState() => new _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String _email;
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

  void reset() async {
    if (validate()) {
      try {
        setState(() {
          load = true;
        });
        await _firebaseAuth.sendPasswordResetEmail(email: _email,);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MailPage(email: _email),
            ));
      } catch (e) {
        switch (e.code) {
          case 'ERROR_INVALID_EMAIL':
            setState(() {
              error_message = '有効なメールアドレスを入力して下さい。';
            });
            break;
          case 'ERROR_USER_NOT_FOUND':
            setState(() {
              error_message = 'アカウントが存在しません。';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('パスワード再設定')),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Icon(Icons.lock_outline, size: 120.0),
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
                              icon: Icon(Icons.refresh),
                              label: Text('パスワード再設定'),
                              onPressed: reset
                          )
                      ),
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

class MailPage extends StatelessWidget {
  final String email;

  MailPage({Key key, @required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('')),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(children: <Widget>[
              Icon(Icons.check, size: 120.0),
              Text(
                'パスワード再設定メールを\n送信しました。',
                style: TextStyle(fontSize: 27.0),
              ),
              Text('$email' + 'にパスワード再設定メールを\n送信しました。\nメールに記載されたURLをクリックして、新しいパスワードを入力して下さい。',
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

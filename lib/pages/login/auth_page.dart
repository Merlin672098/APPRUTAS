import 'package:flutter/material.dart';

import 'login.dart';
import 'login_widget.dart';
import 'signup_widget.dart';

//esto no es una vista

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? MyLogin(onClickedSignUp: toggle)
      : SignUpWidget(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}

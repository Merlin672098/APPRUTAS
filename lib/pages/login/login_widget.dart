import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';
import 'forgot_password_page.dart';


class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(),
              Container(
                padding: const EdgeInsets.only(left: 35, top: 130),
                child: const Text(
                  'Welcome\nBack',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: emailController,
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.cyan),
                      icon: const Icon(Icons.lock_open, size: 32),
                      label: const Text(
                        'Iniciar Sesion',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: signIn,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      child: Text(
                        'Has olvidado tu contraseña?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 20,
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        text: 'No tiene cuenta ?    ',
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignUp,
                            text: 'Registrese',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;
        print("UID del usuario autenticado: $uid");
      } else {
        print("No se pudo obtener el UID del usuario.");
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}


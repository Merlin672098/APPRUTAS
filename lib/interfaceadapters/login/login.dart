import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';
import 'forgot_password_page.dart';

class MyLogin extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const MyLogin({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                '¡Hola!\nBienvenido',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Email",
                              prefixIcon: const Icon(Icons.person, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: passwordController,
                            style: const TextStyle(color: Colors.black),
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Contraseña",
                              prefixIcon: const Icon(Icons.lock, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    signIn();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: widget.onClickedSignUp,
                                child: Text(
                                  'Registrarse',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage(),
                                  ),
                                ),
                                child: const Text(
                                  '¿Olvidaste tu\nContraseña?',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xff4c505b),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
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
      print(e.message ?? 'An error occurred'); // Print the error message for debugging
      Utils.showSnackBar(e.message ?? 'An error occurred');
    } finally {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
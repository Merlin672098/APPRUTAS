import 'package:flutter/material.dart';
import '../../../service/service_usuario.dart';

class HomeVeriPasajero extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Complete su Perfil!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(nombreController, 'Nombre'),
                  const SizedBox(height: 10),
                  _buildTextField(celularController, 'Celular', keyboardType: TextInputType.phone),
                  const SizedBox(height: 10),
                  _buildTextField(correoController, 'Correo', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 10),
                  _buildTextField(contrasenaController, 'Contraseña', isPassword: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      actualizarVerificacion();
                      registrarUsuario();
                    },
                    child: Text('Actualizar Verificación y Registrar Usuario'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? keyboardType, bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.all(12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: isPassword,
      style: TextStyle(fontSize: 16.0),
    );
  }


  void registrarUsuario() {
    String nombre = nombreController.text;
    String celular = celularController.text;
    String correo = correoController.text;
    String contrasena = contrasenaController.text;

    //ServiceUsuario.registrarUsuario(nombre, celular, correo, contrasena);
  }
}

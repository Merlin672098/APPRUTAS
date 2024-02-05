import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';  
  
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('usuarios');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> actualizarVerificacion() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        QuerySnapshot querySnapshot = await usersCollection.where('id', isEqualTo: currentUser.uid).get();

        if (querySnapshot.docs.isNotEmpty) {
          await usersCollection.doc(querySnapshot.docs.first.id).update({'verificacion': true});
          print('Valor de verificacion actualizado a true');
        } else {
          print('Usuario no encontrado');
        }
      } else {
        print('Usuario no autenticado');
      }
    } catch (error) {
      print('Error al actualizar verificacion: $error');
    }
  }
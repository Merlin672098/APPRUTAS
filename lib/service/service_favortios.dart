import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> deleteFav(String id) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userId = user.uid;

    final QuerySnapshot snapshot = await db
        .collection("favoritos")
        .where("lineaId", isEqualTo: id)
        .where("userId", isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      await db.collection("favoritos").doc(snapshot.docs.first.id).delete();
    } else {
      print("No se encontró ningún documento que cumpla con las condiciones.");
    }
  } else {
    print("El usuario no está autenticado.");
  }
}

Future<void> anadirFav(String id) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userId = user.uid;

    final QuerySnapshot snapshot = await db
        .collection("favoritos")
        .where("lineaId", isEqualTo: id)
        .where("userId", isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      await db.collection("favoritos").doc(snapshot.docs.first.id).delete();
    } else {
      print("No se encontró ningún documento que cumpla con las condiciones.");
    }
  } else {
    print("El usuario no está autenticado.");
  }
}
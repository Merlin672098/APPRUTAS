import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/ubicacion.dart';
import '../../../domain/interfaces/ubicacion_repository.dart';

class UbicacionRepositoryImpl implements UbicacionRepository {
  @override
  Future<int> create(Ubicacion ubicacion) async {
    final docUser = FirebaseFirestore.instance.collection('location').doc();

    ubicacion.id = docUser.id;
    final json = ubicacion.toJson();
    await docUser.set(json);
    
    return 1;
  }

  @override
  Future<int> update(Ubicacion ubicacion) async {
    final docRef = FirebaseFirestore.instance.collection('location').doc(ubicacion.id);

    final json = ubicacion.toJson();
    await docRef.update(json);

    return 1;
  }
}
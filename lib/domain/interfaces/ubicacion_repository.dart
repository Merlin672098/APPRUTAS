import '../entities/ubicacion.dart';

abstract class UbicacionRepository {
  Future<int> create(Ubicacion ubicacion);
  Future<int> update(Ubicacion ubicacion);

}

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'funciona.dart';


class PasajerosPage extends StatefulWidget {
  @override
  _PasajerosPageState createState() => _PasajerosPageState();
}

class _PasajerosPageState extends State<PasajerosPage> {
List<LatLng> obtenerListaDeCoordenadas(String nombreDocumento) {

    String nombreLinea = nombreDocumento.toLowerCase(); 

    if (nombreLinea.contains('chroja')) {
      return Chroja;
    }
    else if (nombreLinea.contains('e')) {
      return E;
    }
    return [];
  }
    static const List<LatLng> Chroja = [
      LatLng(-21.520855079224976, -64.71685835219307),
      LatLng(-21.523019767098457, -64.71782839960476),
      LatLng(-21.52705621436634, -64.7195855026763),
      LatLng(-21.52989902126839, -64.72075052897469),
      LatLng(-21.53437931169433, -64.7225949301097),
      LatLng(-21.540883358470165, -64.72504826385602),
      LatLng(-21.540935181927807, -64.7251456182605),
      LatLng(-21.540595103624067, -64.72679305284757),
      LatLng(-21.54049230485556, -64.72706370802769),
      LatLng(-21.540488108984178, -64.72717422559208),
      LatLng(-21.540362232838323, -64.72737721697715),
      LatLng(-21.540387408076235, -64.72793882647585),
      LatLng(-21.540256284411562, -64.72887644009754),
      LatLng(-21.54012780135447, -64.72974461931578),
      LatLng(-21.539848373933342, -64.73049027341831),
      LatLng(-21.53939180831809, -64.73143441099766),
      LatLng(-21.53898560155485, -64.73207867239931),
      LatLng(-21.537797938118633, -64.73162618152602),
      LatLng(-21.53142454353119, -64.7293110806229),
      LatLng(-21.531353209275565, -64.72945317459246),
      LatLng(-21.53083449736962, -64.73078563154496),
      LatLng(-21.53044776488327, -64.73213210046082),
      LatLng(-21.530406404649174, -64.7327665875179),
      LatLng(-21.530367908650796, -64.73352708865066),
      LatLng(-21.530273037906138, -64.73430522831147),
      LatLng(-21.52999638041797, -64.73526061517852),
      LatLng(-21.529619418584474, -64.73599696769381),
      LatLng(-21.527987916590504, -64.7354313771121),
      LatLng(-21.5276860099133, -64.7352221648091),
      LatLng(-21.526124631651737, -64.73471308554362),
      LatLng(-21.5250112177121, -64.73430389979393),
      LatLng(-21.52424767866637, -64.73639065947187),
      LatLng(-21.522262768383335, -64.73561286267459),
      LatLng(-21.52143688779594, -64.73529908177218),
      LatLng(-21.521149938773792, -64.73520520445659),
      LatLng(-21.521267213655218, -64.7354841541959),
      LatLng(-21.521227385789913, -64.73970455733378),
      LatLng(-21.520734575441892, -64.74053072366358),
      LatLng(-21.522102793243825, -64.74155547139169),
      LatLng(-21.52144813668043, -64.74229888693338),
      LatLng(-21.52005330971589, -64.74123136774675),
      LatLng(-21.514294174909683, -64.73706861489998),
      LatLng(-21.514090166617, -64.73688665083448),
      LatLng(-21.51404777810491, -64.7371468745011),
      LatLng(-21.512546086568033, -64.741034505015627),
      LatLng(-21.50956103429883, -64.74094156184142),

    ];
    static const List<LatLng> E = [
      LatLng(-21.510214875367648, -64.73416460474809),
      LatLng(-21.512310995450953, -64.73568809946215),
      LatLng(-21.51408768317933, -64.737018475144487),
      LatLng(-21.51882505845082, -64.74044374513599),
      LatLng(-21.519394566622083, -64.73962750511157),
      LatLng(-21.5207234103669, -64.74055597813984),
      LatLng(-21.522118683192662, -64.74165790217279),
      LatLng(-21.52138782766928, -64.74243333019598),
      LatLng(-21.518426401428364, -64.74435149425337),
      LatLng(-21.51700261728119, -64.74509631328843),
      LatLng(-21.517135504436297, -64.7452289522875),
      LatLng(-21.521425794281278, -64.7424333302039),
      LatLng(-21.523124790035503, -64.74048455713705),
      LatLng(-21.52325767154275, -64.740382527134),
      LatLng(-21.524937662973496, -64.73997440712179),
      LatLng(-21.527054234739545, -64.73949486610431),
      LatLng(-21.527054234739545, -64.73949486610431),
      LatLng(-21.529549515191277, -64.73853185325962),
      LatLng(-21.5307371622915, -64.73515226990781),
      LatLng(-21.532433802069317, -64.72971278341214),
      LatLng(-21.53316980854271, -64.7270949672903),
      LatLng(-21.53257599618091, -64.72690184824202),
      LatLng(-21.533868408228454, -64.72463806383345),
      LatLng(-21.534946241145978, -64.72147842161472),
      LatLng(-21.535589943099048, -64.71964915506375),
      LatLng(-21.53562986250269, -64.71932192556342),
      LatLng(-21.533658828688147, -64.71646269075843),
      LatLng(-21.532149299537267, -64.7146253901124),
      LatLng(-21.53055245713697, -64.71161060036233),
      LatLng(-21.52878098407738, -64.71030704971088),
      LatLng(-21.527373748168866, -64.70945942524293),
    
    ];
  List<LatLng> rutaSeleccionada = Chroja;
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Porfa no me mates'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('lineas').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.docs[index]['nombre'].toString()),
                      subtitle: const Row(),
                      trailing: IconButton(
                        icon: const Icon(Icons.directions),
                        onPressed: () {
                          String nombreDocumento = snapshot.data!.docs[index]['nombre'].toString();
                          List<LatLng> listaCoordenadas = obtenerListaDeCoordenadas(nombreDocumento);

                          String selectedUserId = snapshot.data!.docs[index].id;
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Funciona(selectedUserId, listaCoordenadas),
                          ));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

   Future<Position> _requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('La ubi no esta disponible');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos fueron denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('La ubicaion esta permanentementedenegada');
    }

    return await Geolocator.getCurrentPosition();
  }
}
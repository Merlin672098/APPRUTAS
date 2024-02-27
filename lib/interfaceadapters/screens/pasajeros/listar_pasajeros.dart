import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutasmicros/pruebaprovider.dart';
import 'funciona.dart';

class PasajerosPage extends StatefulWidget {
  @override
  _PasajerosPageState createState() => _PasajerosPageState();
}

class _PasajerosPageState extends State<PasajerosPage> {
   List<bool> isFavoriteList = [];
  bool cargaInicialRealizada = false;
int batchSize = 10;
  int loadedCount = 0;

  List<LatLng> obtenerListaDeCoordenadas(String nombreDocumento) {
    String nombreLinea = nombreDocumento.toLowerCase();

    if (nombreLinea == 'chroja') {
      return Chroja;
    } else if (nombreLinea == 'e') {
      return E;
    } else if (nombreLinea == 'linea1') {
      return LINEA1;
    }
    return [];
  }

 
  static const List<LatLng> LINEA1 = [
    LatLng(-21.511420895331653, -64.72382968642648),
    LatLng(-21.51670018039096, -64.72590836894106),
    LatLng(-21.516078017476854, -64.72717292133098),
    LatLng(-21.516152124041337, -64.72725637210375),
    LatLng(-21.517040517096767, -64.72758589092325),
    LatLng(-21.519276272482795, -64.72840128244206),
    LatLng(-21.521022959967613, -64.72930788671614),
  ];

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

  static const List<LatLng> linea5 = [
    LatLng(-21.521358906315033, -64.71435230004573),
    LatLng(-21.520936810774312, -64.71509007089732),
    LatLng(-21.520783995311156, -64.7168513496066),
    LatLng(-21.522068099982704, -64.71735657260948),
    LatLng(-21.524541375572927, -64.71849847587957),
    LatLng(-21.526236683235904, -64.71923826675328),
    LatLng(-21.528141782601317, -64.72002316679517),
    LatLng(-21.528818875333027, -64.72031153674828),
    LatLng(-21.52898672351362, -64.72032958042696),
    LatLng(-21.52933081168902, -64.72049873992648),
    LatLng(-21.529691683773482, -64.72067241034684),
    LatLng(-21.529542064306256, -64.72083226258331),
    LatLng(-21.5280204476473, -64.72211808745041),
    LatLng(-21.526039389666096, -64.7234459833825),
    LatLng(-21.526105759997055, -64.72362319624497),
    LatLng(-21.526480087222257, -64.7243915192112),
    LatLng(-21.52732338391119, -64.7252367222351),
    LatLng(-21.527228621230233, -64.72513717330754),
    LatLng(-21.528174469494708, -64.72609411066678),
    LatLng(-21.529423585347445, -64.72660240163472),
    LatLng(-21.530362179501413, -64.72707276049633),
    LatLng(-21.533676299835538, -64.72857066247731),
    LatLng(-21.533640734052252, -64.72866906959672),
    LatLng(-21.533192969653733, -64.7299841038328),
    LatLng(-21.532670654223324, -64.73164412234074),
    LatLng(-21.532670654223324, -64.73164412234074),
    LatLng(-21.53186968663777, -64.73403005541526),
    LatLng(-21.53134702793763, -64.73566741041846),
    LatLng(-21.531047911796826, -64.73667727076243),
    LatLng(-21.530850791609986, -64.73734785234963),
    LatLng(-21.531015444833834, -64.73741717009759),
    LatLng(-21.531601449909374, -64.73761470754579),
    LatLng(-21.533029355728324, -64.73809880217014),
    LatLng(-21.53457222933408, -64.73864105151111),
    LatLng(-21.533688816306597, -64.73946883752544),
    LatLng(-21.533187381119685, -64.73985160178381),
    LatLng(-21.532644404985174, -64.74008763974),
    LatLng(-21.53237439970595, -64.74031729827585),
    LatLng(-21.53219556279704, -64.74051824062603),
    LatLng(-21.53226542338396, -64.74077573267874),
    LatLng(-21.53266084784786, -64.74108397049991),
    LatLng(-21.532860041908588, -64.74184192732953),
    LatLng(-21.53289263333235, -64.74227388457022),
    LatLng(-21.53295197498322, -64.74258647535514),
    LatLng(-21.53314483518646, -64.7427332016725),
    LatLng(-21.53368780944466, -64.74324674367628),
    LatLng(-21.5339370428505, -64.74340941847251),
    LatLng(-21.534044067914454, -64.74344139329503),
    LatLng(-21.53425177253575, -64.74334666398197),
    LatLng(-21.534761591710286, -64.74317975995424),
    LatLng(-21.535181656928327, -64.74313422487239),
    LatLng(-21.53575132679487, -64.74293008395162),
    LatLng(-21.535599746454324, -64.74300703515388),
    LatLng(-21.536258518686722, -64.74274540181311),
    LatLng(-21.53647251411901, -64.74286719664416),
  ];
  List<LatLng> rutaSeleccionada = Chroja;

  @override
  void initState() {
    super.initState();
    //_requestPermission();
    _realizarCargaInicial();
    

  }

  Color _generateColor(int index) {
    if (index == 0) {
      return Colors.red;
    } else {
      int red = (index * 50) % 256;
      int green = (index * 30) % 256;
      int blue = (index * 20) % 256;

      return Color.fromARGB(255, red, green, blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RUTAS'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('lineas').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  if (index < 0 || index >= snapshot.data!.docs.length) {
                    return const SizedBox(); 
                  }

                  final String lineaId = snapshot.data!.docs[index].id;

                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Seleccionar dirección'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.arrow_upward),
                                      onPressed: () {
                                        //Navigator.pop(context); r
                                        //_handleDirectionSelection(lineaId, 'ida', snapshot.data!, index);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_downward),
                                      onPressed: () {
                                        //Navigator.pop(context); r
                                        //_handleDirectionSelection(lineaId, 'vuelta',snapshot.data!, index);
                                      },
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context); 
                                       _handleDirectionSelection(lineaId, 'ida', snapshot.data!, index);
                                      },
                                      child: Text('Ida'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context); 
                                        _handleDirectionSelection(lineaId, 'vuelta',snapshot.data!, index);
                                      },
                                      child: Text('Vuelta'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: themeProvider.isDarkModeEnabled ? Colors.blueGrey[800] : Colors.blueGrey[50],
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _generateColor(index),
                        ),
                        title: Text(
                          snapshot.data!.docs[index]['nombre'].toString(),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeProvider.isDarkModeEnabled ? Colors.white : Colors.black),
                        ),
                        subtitle: Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Número de paradas: ${snapshot.data!.docs[index]['numeroDeParadas']}',
                              style: TextStyle(fontSize: 14, color: themeProvider.isDarkModeEnabled ? Colors.grey : Colors.black),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isFavoriteList.isNotEmpty && isFavoriteList[index]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavoriteList.isNotEmpty && isFavoriteList[index] ? Colors.red : null,
                          ),
                          onPressed: () async {
                            if (isFavoriteList.isNotEmpty && isFavoriteList[index]) {
                              quitarFav(lineaId);
                            } else {
                              anadirFav(lineaId);
                            }

                            setState(() {
                              if (isFavoriteList.isNotEmpty) {
                                isFavoriteList[index] = !isFavoriteList[index];
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

 void _realizarCargaInicial() async {
    List<QueryDocumentSnapshot> documentos = (await FirebaseFirestore.instance
            .collection('lineas')
            .limit(batchSize)
            .get())
        .docs;

    if (isFavoriteList.length != documentos.length) {
      setState(() {
        isFavoriteList = List.generate(documentos.length, (index) => false);
      });
    }

    for (int i = 0; i < documentos.length; i++) {
      String lineaId = documentos[i].id;
      bool esFavorito = await usuarioTieneFavoritos(lineaId);
      setState(() {
        isFavoriteList[i] = esFavorito;
      });
    }

    loadedCount += batchSize;


    setState(() {
      cargaInicialRealizada = true;
    });
  }



void quitarFav(String lineaId) async {
    try {
      String? userId = await obtenerUserIdActual();

      if (userId != null) {
        CollectionReference favoritosCollection = FirebaseFirestore.instance.collection('favoritos');

        QuerySnapshot existingRelation = await favoritosCollection
            .where('lineaId', isEqualTo: lineaId)
            .where('userId', isEqualTo: userId)
            .get();

        existingRelation.docs.forEach((doc) {
          doc.reference.delete();
        });

        print('quitada de favoritos');
      } else {
        print('No se pudo obtener el ID ');
      }
    } catch (error) {
      print('Error al quitar de favoritos: $error');
    }
  }

Future<bool> usuarioTieneFavoritos(String lineaId) async {
    try {
      String? userId = await obtenerUserIdActual();

      if (userId != null) {
        CollectionReference favoritosCollection = FirebaseFirestore.instance.collection('favoritos');

        QuerySnapshot existingRelation = await favoritosCollection
            .where('lineaId', isEqualTo: lineaId)
            .where('userId', isEqualTo: userId)
            .get();

        return existingRelation.docs.isNotEmpty;
      } else {
        print('No se pudo obtener el ID del usuario actual');
        return false;
      }
    } catch (error) {
      print('Error al verificar si el usuario tiene favoritos: $error');
      return false;
    }
  }

Future<String?> obtenerUserIdActual() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  } catch (error) {
    print('Error al obtener el ID del usuario actual: $error');
    return null;
  }
}
  void anadirFav(String lineaId) async {
    try {
      String? userId = await obtenerUserIdActual(); 

      CollectionReference favoritosCollection = FirebaseFirestore.instance.collection('favoritos');

      QuerySnapshot existingRelation = await favoritosCollection
          .where('lineaId', isEqualTo: lineaId)
          .where('userId', isEqualTo: userId)
          .get();

      if (existingRelation.docs.isEmpty) {
        await favoritosCollection.add({
          'lineaId': lineaId,
          'userId': userId,
        });

        print('añadida a favoritos');
      } else {
        print('La relación ya existe en favoritos');
      }
    } catch (error) {
      print('Error al añadir a favoritos: $error');
    }
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
      return Future.error('La ubicación esta permanentemente denegada');
    }

    return await Geolocator.getCurrentPosition();
  }

  
  void _handleDirectionSelection(String lineaId, String direccion, QuerySnapshot snapshot, int index) {
    String nombreDocumento = snapshot.docs[index]['nombre'].toString();
    List<LatLng> listaCoordenadas = obtenerListaDeCoordenadas(nombreDocumento);
    String selectedUserId = snapshot.docs[index].id;

    if (direccion == 'ida') {
      print('Seleccionaste dirección de ida');
    } else if (direccion == 'vuelta') {
      print('Seleccionaste dirección de vuelta');
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Funciona(selectedUserId, listaCoordenadas),
    ));
  }


}



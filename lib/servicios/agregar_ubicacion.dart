import "package:flutter/material.dart";
import 'package:ms24hs/models/UbicacionServicio.dart';
import 'package:ms24hs/varglobal.dart' as global;
import 'package:ms24hs/provider/appBar.dart';
import 'package:ms24hs/service/sharedPreferences.dart';
import 'package:ms24hs/provider/adressInput.dart';
import 'package:ms24hs/address_search.dart';
import 'package:ms24hs/service/google_places.dart';
import 'package:uuid/uuid.dart';
import 'package:ms24hs/service/webService.dart';
import 'package:google_place/google_place.dart' as google;
import 'package:ms24hs/models/agenda.dart';
import "package:ms24hs/db/dataBase.dart";
import 'package:ms24hs/models/valores.dart';
import "package:ms24hs/provider/pantallaCarga.dart";

class Ubicaciones extends StatefulWidget {
  final UbicacionServicios? ubicaciones;
  final int? idServicio;
  const Ubicaciones({
    Key? key,
    this.ubicaciones,
    this.idServicio,
  }) : super(key: key);

  @override
  State<Ubicaciones> createState() => _Ubicaciones();
}

class _Ubicaciones extends State<Ubicaciones> {
  UbicacionServicios? listaUbicacion;
  final GlobalKey _ModalCarga = new GlobalKey();
  final _localidadController = TextEditingController();
  String lat = "", long = "";
  int idServicioGeneral = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listaUbicacion = widget.ubicaciones;
    idServicioGeneral = widget.idServicio!;
    print("idServio ------------> " + idServicioGeneral.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMenu("- Ubicaciones"),
      drawer: menuLateral(),
      body: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            // ignore: avoid_unnecessary_containers
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Expanded(
                  child: Text(
                    "Ubicaciones",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // ignore: deprecated_member_use
                RaisedButton(
                    child: const Text("Agregar ubicacion"),
                    color: Colors.green[600],
                    onPressed: modalAgregarUbicacion),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
                child: Row(children: [
                  Expanded(
                    child: DataTable(
                      border: const TableBorder(
                        left: BorderSide(color: Color(0xFFBDBDBD)),
                        bottom: BorderSide(color: Color(0xFFBDBDBD)),
                        right: BorderSide(color: Color(0xFFBDBDBD)),
                        top: BorderSide(color: Color(0xFFBDBDBD)),
                      ),
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Localidad',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: _generarListadoUbicaciones(listaUbicacion),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void modalAgregarUbicacion() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
              ),
              title: Container(
                child: const Center(
                  child: Text("Agregar ubicacion"),
                ),
              ),
              content: Wrap(
                children: [
                  Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          // ignore: prefer_const_constructors
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, top: 10, left: 10, right: 10),
                            // ignore: prefer_const_constructors
                            child: AdressInput(
                              controller: _localidadController,
                              enabled: true,
                              hintText: "Localidad",
                              iconData: Icons.gps_fixed,
                              onTap: searchLoc,
                            ),
                          ), //Fin del input de la localidad
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      )
                    ],
                  ), // Ubicacion
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          color: Colors.green[600],
                          child: const Text("Agregar"),
                          onPressed: agregarUbicacion,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }

  searchLoc() async {
    final sessionToken = Uuid().v4();
    final Suggestion? result = await showSearch(
      context: context,
      delegate: AddresSearch(sessionToken),
    );

    if (result != null) {
      String latR = "";
      String longR = "";
      PlaceApiProvider a =
          AddresSearch(sessionToken).PlaceDetail(result.placeId);
      await a.getPlaceDetailFromId(result.placeId).then((Place val) {
        latR = val.lat;
        longR = val.long;
      });
      setState(() {
        _localidadController.text = result.description;
        lat = latR;
        long = longR;
      });
    }
  }

  List<DataRow> _generarListadoUbicaciones(UbicacionServicios? ubicacion) {
    List<DataRow> lista = [];
    ubicacion!.data!.forEach((element) {
      lista.add(
        DataRow(cells: <DataCell>[
          DataCell(
            Text(
              element.localidad.toString(),
              textAlign: TextAlign.start,
            ),
          ),
          DataCell(
            const Icon(Icons.delete),
            onTap: () {
              eliminarUbicacion(element.idubicacion!);
            },
          ),
        ]),
      );
    });
    return lista;
  }

  Future<void> obtenerUbicaciones(int idServicio) async {
    UbicacionServicios? ubicaciones =
        await WebService().getLocationService(idServicio);
    setState(() {
      listaUbicacion = ubicaciones;
    });
    Navigator.of(context).pop('Ok'); //para cerrar el cargando
    _localidadController.text = "";
    Navigator.of(context).pop('Ok'); //para cerrar el modal de agregar ubicacion
  }

  Future<void> eliminarUbicacion(int idServicio) async {
    PantallaCarga.cargandoDatos(context, _ModalCarga, "");
    await WebService()
        .eliminarUbicacionServicio(idServicio)
        .then((int? resultado) {
      print("El resultado de la eliminacion es " + resultado.toString());
      if (resultado == 1) //Si esta todo ok obtengo de nuevo las ubicaciones
      {
        obtenerUbicaciones(idServicio);
      } else {
        //Aca muestro mensaje de error
      }
    });
  }

  Future<void> agregarUbicacion() async {
    PantallaCarga.cargandoDatos(context, _ModalCarga, "");
    int? resultado = await WebService().agregarUbicacionServicio(
        idServicioGeneral, _localidadController.text, lat, long);
    if (resultado == 1) //Se agrego correctamente
    {
      obtenerUbicaciones(idServicioGeneral);
    }
  }

  Widget? menuLateral() {
    if (global.logeado) {
      return Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(global.datosUsuario!.nombre.toString()),
              accountEmail: Text(
                  global.datosUsuario!.correo.toString() +
                      " - " +
                      global.datosUsuario!.nivelUsuario.toString(),
                  maxLines: 2),
            ),
            Container(
                height: MediaQuery.of(context).size.height / 1.4,
                child: listadoMenu(context)),
            RaisedButton.icon(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                onPressed: cerrarSesion,
                icon: const Icon(Icons.door_back_door),
                label: const Text("Cerrar sesion",
                    style: TextStyle(color: Colors.white, fontSize: 21)))
          ],
        ),
      );
    } else {
      return null;
    }
  }

  Future<void> cerrarSesion() async {
    SharedPreferencesService().cerrarSesion().then((bool result) {
      if (result) {
        setState(() {
          global.logeado = false;
          global.datosUsuario =
              null; // Cargo los datos del usuario en la variable global
        });
      }
    });
  }
}

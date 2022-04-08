// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import "package:http/http.dart" as http;
import 'package:ms24hs/address_search.dart';
import 'package:ms24hs/buscador.dart';
import 'package:ms24hs/service/google_places.dart';
import 'package:uuid/uuid.dart';
import "varglobal.dart" as global;
import 'provider/modal.dart' as modales;
import 'provider/splashScree.dart' as splash;
import "models/categorias.dart";
import "models/subCategorias.dart";
import 'package:rflutter_alert/rflutter_alert.dart';
import 'models/busqueda.dart';
import 'package:google_place/google_place.dart' as google;
import 'package:location/location.dart';
import 'provider/adressInput.dart';

class Inicio extends StatefulWidget {
  final List<Categorias> categoriasLista;
  final List<SubCategorias> subCategoriaLista;
  const Inicio(
      {Key? key,
      required this.categoriasLista,
      required this.subCategoriaLista})
      : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final _localidadController = TextEditingController();

  String _subCategoriaLabel = "Seleccione una sub-categoría";
  String _subCategoria = "Seleccione una categoría";
  Categorias? _catVal;
  SubCategorias? _subCatVal;
  List<Categorias> catList = [];
  List<SubCategorias> subCatList = [];

  bool esProf = false;

  /**Para obtener la ubicacion */
  Location location = new Location();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.granted;
  LocationData _locationData = LocationData.fromMap({});

  google.GooglePlace googlePlace = google.GooglePlace(global.googleKey);
  List<google.AutocompletePrediction> predictions = [];

  void getLocation() async {
    final sessionToken = Uuid().v4();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    PlaceApiProvider a = AddresSearch(sessionToken).currentLocation(
        _locationData.latitude.toString(), _locationData.longitude.toString());
    String nombreLocalizacion = await a
        .getCurrentLocation(_locationData.latitude.toString(),
            _locationData.longitude.toString())
        .then((String val) {
      return val;
    });

    setState(() {
      global.latMovil = _locationData.latitude.toString();
      global.longMovil = _locationData.longitude.toString();
      _localidadController.text = nombreLocalizacion;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _localidadController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    _catVal = widget.categoriasLista[0];
    catList = widget.categoriasLista;
    subCatList = widget.subCategoriaLista;
    _subCatVal = widget.subCategoriaLista[0];
  }

  searchLoc() async {
    final sessionToken = Uuid().v4();
    final Suggestion? result = await showSearch(
      context: context,
      delegate: AddresSearch(sessionToken),
    );

    if (result != null) {
      String lat = "";
      String long = "";
      PlaceApiProvider a =
          AddresSearch(sessionToken).PlaceDetail(result.placeId);
      await a.getPlaceDetailFromId(result.placeId).then((Place val) {
        lat = val.lat;
        long = val.long;
      });
      setState(() {
        _localidadController.text = result.description;
        global.latMovil = lat;
        global.longMovil = long;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      color: Colors.yellow[600],
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/img/logo-sos.png",
                  width: MediaQuery.of(context).size.width / 2,
                  height: 200,
                ),
              ), //Imagen de la empresa
              const Padding(
                padding: const EdgeInsets.only(top: 10),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                margin: const EdgeInsets.only(
                    bottom: 10, top: 10, left: 30, right: 30),
                child: DropdownButton(
                  isExpanded: true,
                  items: catList.map((Categorias item) {
                    return DropdownMenuItem(
                      child: Text(item.nombreCategoria,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 13)),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (Categorias? c) {
                    setState(() {
                      obtenerSubCategoria(c!.idCategoria);
                      _catVal = c;
                    });
                  },
                  value: _catVal,
                ),
              ), //Categorias
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                margin: const EdgeInsets.only(
                    bottom: 10, top: 10, left: 30, right: 30),
                child: DropdownButton(
                  isExpanded: true,
                  items: subCatList.map((SubCategorias item) {
                    return DropdownMenuItem(
                      child: Text(item.subcatNombre,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 13)),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (SubCategorias? c) {
                    setState(() {
                      _subCatVal = c;
                    });
                  },
                  value: _subCatVal,
                ),
              ),
              //Sub categorias
              Container(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        // ignore: prefer_const_constructors
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, top: 10, left: 40, right: 40),
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
                ),
              ), //Inputs

              const Padding(
                padding: const EdgeInsets.only(top: 30),
              ),
              RaisedButton.icon(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                //shape: CircleBorder(),
                onPressed: () async {
                  Busqueda resultado = await obtenerBusqueda();
                },
                color: Colors.green[600],
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                label: const Text(
                  "Buscar",
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ), //Icon(Icons.search, color: Colors.black87,),
              ), //Botón de busqueda,
              const Divider(
                indent: 75,
                endIndent: 75,
                color: Colors.black87,
              ),
              const Padding(padding: const EdgeInsets.only(top: 10)),
              ElevatedButton(
                  onPressed: () =>
                      modalRegistroLogin(this.context, "L", esProf).show(),
                  child: const Text("Iniciar Sesion",
                      style: TextStyle(color: Colors.white, fontSize: 21))),
              const Padding(padding: const EdgeInsets.only(top: 10)),
              ElevatedButton(
                onPressed: () =>
                    modalRegistroLogin(this.context, "R", esProf).show(),
                child: const Text("Crear cuenta",
                    style: const TextStyle(color: Colors.white, fontSize: 21)),
                style: const ButtonStyle(),
              )
            ],
          ),
        ],
      ),
    ));
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  Future<Busqueda> obtenerBusqueda() async {
    Busqueda data = Busqueda(codigo: 1000, datosBusqueda: []);
    String idCategoria = _catVal!.idCategoria.toString();
    String idSubCategoria = _subCatVal!.subcatId.toString();
    if (idSubCategoria == "0") {
      idSubCategoria = "-";
    }
    Uri url = Uri.https(
        global.baseUrl,
        global.project + global.wsUrl + "ws/buscar",
        {"c": idCategoria, "sc": idSubCategoria});
    await http
        .get(url, headers: {"Accept": "application/json"}).then((respuesta) {
      String body = utf8.decode(respuesta.bodyBytes);
      var datos = jsonDecode(body);
      data = Busqueda.fromJson(datos);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Buscador(busqueda: data)));
    });
    return data;
  }

  Future<String> obtenerSubCategoria(int idCategoria) async {
    List<SubCategorias> subCat = [];
    subCat.add(SubCategorias(
        subcatCatId: 0,
        subcatId: 0,
        subcatNombre: "Seleccione una sub categorias",
        subcatVigente: ""));
    Uri url = Uri.https(
        global.baseUrl,
        global.project + global.wsUrl + "ws/subCategoria/obtener",
        {"idCategoria": idCategoria.toString()});
    await http
        .get(url, headers: {"Accept": "application/json"}).then((respuesta) {
      String body = utf8.decode(respuesta.bodyBytes);
      var datos = jsonDecode(body);
      for (var item in datos) {
        subCat.add(SubCategorias(
            subcatId: item["subcat_id"],
            subcatCatId: item["subcat_cat_id"],
            subcatNombre: item["subcat_nombre"]));
      }
      setState(() {
        subCatList = subCat;
        _subCatVal = subCatList[0];
      });
    });
    return "Ok";
  }

  Alert modalRegistroLogin(BuildContext context, String tipo, bool esProf) {
    String titulo = "Registro";
    if (tipo == "L") //Es login
    {
      titulo = "Iniciar sesion";
    }
    Widget contenido = Column(
      /**
       * 
       * 
        if(true) ... [

        ],
       */
      children: [
        FlutterSwitch(
          activeText: "All Good. Negative.",
          inactiveText: "Under Quarantine.",
          value: esProf,
          valueFontSize: 10.0,
          width: 110,
          borderRadius: 30.0,
          showOnOff: true,
          onToggle: (val) {
            setState(() {
              esProf = val;
            });
          },
        ),
        const TextField(
            decoration: const InputDecoration(
          hintText: "Nombre",
        )),
        const TextField(decoration: InputDecoration(hintText: "Apellido")),
        const TextField(decoration: const InputDecoration(hintText: "Cod cel")),
        const TextField(
            decoration: const InputDecoration(
                hintText: "Numero de celular",
                icon: const Icon(Icons.numbers))),
        const TextField(
            decoration: const InputDecoration(
                hintText: "Correo electronico", icon: const Icon(Icons.email))),
        const TextField(
            decoration: const InputDecoration(
                hintText: "Clave", icon: const Icon(Icons.lock))),
        const TextField(
          decoration: const InputDecoration(
              hintText: "Confirmar clave", icon: const Icon(Icons.lock)),
        ),
      ],
    );
    DialogButton cancelar = DialogButton(
      onPressed: () => Navigator.pop(context),
      child: const Text(
        "Cancelar",
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
    DialogButton accionBoton = DialogButton(
      onPressed: () => Navigator.pop(context),
      child: const Text(
        "Registrarse",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );

    if (tipo == "L") {
      accionBoton = DialogButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "Iniciar sesion",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
      contenido = Column(
        children: [
          const TextField(
              decoration: const InputDecoration(
                  hintText: "Correo electronico",
                  icon: const Icon(Icons.email))),
          const TextField(
              decoration: const InputDecoration(
                  hintText: "Clave", icon: Icon(Icons.lock))),
        ],
      );
    }

    return Alert(
        context: context,
        title: titulo,
        content: contenido,
        buttons: [accionBoton, cancelar]);
  }
}

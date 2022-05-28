// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:ms24hs/service/webService.dart';
import "inicio.dart";
import "varglobal.dart" as global;
import 'provider/splashScree.dart' as splash;
import 'provider/servicios.dart';
import 'models/subCategorias.dart';
import "models/categorias.dart";
import 'models/busqueda.dart';
import 'package:ms24hs/provider/adressInput.dart';
import 'package:ms24hs/address_search.dart';
import 'package:ms24hs/service/google_places.dart';
import 'package:uuid/uuid.dart';

class Buscador extends StatefulWidget {
  final Busqueda busqueda;
  const Buscador({
    Key? key,
    required this.busqueda,
  }) : super(key: key);

  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime diaHoy = DateTime.now();
  TextEditingController _horaController = TextEditingController(),
      _diaController = TextEditingController(),
      _localidadController = TextEditingController(),
      _descripcionController = TextEditingController();
  String lat = "", long = "";

  List<Widget> listadoResultado(Busqueda resultado) {
    List<Widget> lista = [];
    resultado.datosBusqueda!.forEach((element) {
      lista.add(
        mostrarServicio(
            context,
            element.urlImagen.toString(),
            element.nombreServicio.toString(),
            element.descripcionServicio.toString(),
            element.idServicio!,
            element.localidadNombre.toString(),
            element.contacto.toString()),
      );
    });
    return lista;
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _diaController.text = "${diaHoy.day}/${diaHoy.month}/${diaHoy.year}";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text("MS24HS"),
        centerTitle: true,
        backgroundColor: Colors.yellow[600],
      ),
      body: Container(
        color: global.fondoGris,
        alignment: Alignment.center,
        child: ListView(scrollDirection: Axis.vertical, children: [
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: listadoResultado(widget.busqueda),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget mostrarServicio(
      BuildContext context,
      String urlImagen,
      String nombreServicio,
      String descripcionServicio,
      int idServicio,
      String localidad,
      String contacto) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white70, width: 10.0),
                    // ignore: prefer_const_constructors
                    borderRadius: BorderRadius.all(
                      const Radius.circular(32.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[700]!,
                        offset: const Offset(-8, 8),
                        blurRadius: 10,
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.network(
                        'https://' +
                            global.baseUrl +
                            global.project +
                            global.imgUrl +
                            urlImagen.toString(),
                        scale: 0.8,
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.width / 1.5,
                        alignment: Alignment.center,
                      ),
                    ), //Imagen del servicio
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(
                              nombreServicio.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(padding: EdgeInsets.only(top: 6)),
                            Text(
                              "Localidad:" + localidad,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontSize: 16),
                            ),
                            Padding(padding: EdgeInsets.only(top: 6)),
                            Container(
                              child: Text(
                                "Contacto:" + contacto,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 6)),
                            Text(
                              descripcionServicio.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ), //Titulo y descripcion del servicio
                    if (global.logeado) ...[
                      RaisedButton(
                        onPressed: () {
                          abrirModalReserva(idServicio);
                        },
                        padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          child: const Text(
                            "Reservar",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        color: const Color.fromARGB(255, 53, 126, 235),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void abrirModalReserva(int idServicio) async {
    showDialog(
        context: context,
        builder: (BuildContext contect) {
          return AlertDialog(
            title: Container(
                child: Center(
              child: Text("Reservar"),
            )),
            content: Container(
              child: Wrap(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: TextField(
                              readOnly: false,
                              controller: _diaController,
                              autofocus: false,
                              onTap: () => _selectDay(context),
                            ),
                            padding: EdgeInsets.only(right: 10),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: TextField(
                              readOnly: false,
                              autofocus: false,
                              controller: _horaController,
                              onTap: () => _selectTime(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      // ignore: prefer_const_constructors
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, top: 10, left: 0, right: 0),
                        // ignore: prefer_const_constructors
                        child: AdressInput(
                          controller: _localidadController,
                          enabled: true,
                          hintText: "Direccion",
                          iconData: Icons.gps_fixed,
                          onTap: searchLoc,
                        ),
                      ), //Fin del input de la localidad
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  Container(
                    child: TextField(
                      minLines: 1,
                      maxLines: 5000,
                      keyboardType: TextInputType.multiline,
                      controller: _descripcionController,
                    ),
                  )
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.red[400],
                        onPressed: () => Navigator.of(context).pop("oK"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: RaisedButton(
                        child: Text(
                          "Reservar",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.green[400],
                        onPressed: () => realizarReserva(idServicio),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }

  realizarReserva(int idServicio) async {
    String dia, hora, lugar, descripcion, lt, ln, msg = "";
    dia = _diaController.text;
    hora = _horaController.text;
    lugar = _localidadController.text;
    lt = lat;
    ln = long;
    descripcion = _descripcionController.text;
    if (dia.isNotEmpty) {
      if (lugar.isNotEmpty && lt.isNotEmpty && ln.isNotEmpty) {
        if (descripcion.isNotEmpty) {
          await WebService()
              .generarReserva(
                  idServicio.toString(), dia, hora, lugar, lt, ln, descripcion)
              .then((value) {
            Navigator.of(context).pop('Ok'); //cierro el cargando
            // Navigator.of(context).pop('Ok'); //cierro la reserva
            setState(() {
              _diaController.text =
                  "${diaHoy.day}/${diaHoy.month}/${diaHoy.year}";
              _horaController.text = "";
              _localidadController.text = "";
              lat = "";
              long = "";
            });
            mensaje("Se realizo la petición de la reserva correctamente.");
          });
        } else {
          msg = "La descripcion de la reserva no puede ser vacia";
        }
      } else {
        msg = "La direccion de la reserva es obligatoria";
      }
    } else {
      msg = "El dia de la resera es obligatorio";
    }
    if (msg != "") {
      mensaje(msg);
    }
  }

  void mensaje(String mensaje) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
              ),
              title: Container(
                child: const Text(
                  "Mensaje",
                  textAlign: TextAlign.center,
                ),
              ),
              content: Wrap(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Container(
                    child: Center(
                      child: Text(mensaje),
                    ),
                  ),
                ],
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop('Ok'); //para cerrar el modal
                    },
                    child: Text("Cerrar"),
                  ),
                ),
              ],
              //Botones de accion
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

  _selectTime(BuildContext context) async {
    TimeOfDay? hora = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: selectedTime,
    );

    if (hora != null && hora != selectedTime) {
      setState(() {
        _horaController.text = "${hora.hour}:${hora.minute}";
      });
    }
  }

  _selectDay(BuildContext context) async {
    final DateTime? dia = await showDatePicker(
      context: context,
      initialDate: diaHoy,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 30),
    );

    if (dia != null && dia != diaHoy) {
      setState(() {
        _diaController.text = "${dia.day}/${dia.month}/${dia.year}";
      });
    }
  }
}

// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import "package:http/http.dart" as http;
import 'package:ms24hs/address_search.dart';
import 'package:ms24hs/buscador.dart';
import 'package:ms24hs/inicio.dart';
import 'package:ms24hs/provider/pantallaCarga.dart';
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
import 'service/webService.dart' as webService;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/usuario.dart';
import 'service/sharedPreferences.dart';
import 'provider/appBar.dart';
import 'agenda.dart';
import 'package:ms24hs/registro.dart';

class Registro extends StatefulWidget {
  List<Categorias> categorias;
  List<SubCategorias> subCategorias;
  Registro({
    Key? key,
    required this.categorias,
    required this.subCategorias,
  }) : super(key: key);

  @override
  State<Registro> createState() => _Registro();
}

class _Registro extends State<Registro> {
  bool esProf = false;
  final GlobalKey _ModalCarga = new GlobalKey();
  String text = "Usuario";
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _celularController = TextEditingController();
  TextEditingController _claveController = TextEditingController();
  TextEditingController _confirmarClaveController = TextEditingController();
  List<Categorias> catList = [];
  List<SubCategorias> subCatList = [];
  Categorias? _catVal;
  SubCategorias? _subCatVal;

  @override
  void initState() {
    super.initState();
    _catVal = widget.categorias[0];
    catList = widget.categorias;
    subCatList = widget.subCategorias;
    _subCatVal = widget.subCategorias[0];
  }

  void registrarUsuario() async {
    String? nombre,
        apellido,
        contacto,
        correo,
        clave,
        confiClave,
        txtMensjae = "",
        prof = "N";
    int idCategoria = 0, idSubCategoria = 0;
    if (esProf) {
      prof = "S";
      idCategoria = _catVal!.idCategoria;
      idSubCategoria = _subCatVal!.subcatCatId;
    }
    nombre = _nombreController.text;
    apellido = _apellidoController.text;
    contacto = _celularController.text;
    correo = _emailController.text;
    clave = _claveController.text;
    confiClave = _confirmarClaveController.text;
    if ((esProf == true && idCategoria != 0) || esProf == false) {
      if (nombre.isNotEmpty) {
        if (apellido.isNotEmpty) {
          if (contacto.isNotEmpty) {
            if (correo.isNotEmpty) {
              bool emailValid = RegExp(
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                  .hasMatch(correo);
              if (emailValid) {
                if (clave.isNotEmpty) {
                  if (confiClave.isNotEmpty) {
                    if (clave == confiClave) {
                      PantallaCarga.cargandoDatos(
                          context, _ModalCarga, "Creando usuario");
                      await webService.WebService()
                          .registroUsuario(prof, idCategoria, idSubCategoria,
                              nombre, apellido, correo, clave, contacto)
                          .then((value) {
                        if (prof == "S") {
                          Navigator.of(context).pop("OK");
                          mensaje(
                              "Se envio la solicitud de registro correctamente.");
                          setState(() {
                            _catVal = catList[0];
                            _subCatVal = subCatList[0];
                            esProf = false;
                            _nombreController.text = "";
                            _apellidoController.text = "";
                            _celularController.text = "";
                            _emailController.text = "";
                            _claveController.text = "";
                            _confirmarClaveController.text = "";
                          });
                        } else {
                          iniciarSesion();
                        }
                      });
                    } else {
                      txtMensjae = "Las claves no coinciden";
                    }
                  } else {
                    txtMensjae = "La confirmacion de la clave es obligatoria";
                  }
                } else {
                  txtMensjae = "La clave es obligatoria";
                }
              } else {
                txtMensjae = "El correo electronico no es valido.";
              }
            } else {
              txtMensjae = "El correo electronico es obligatorio";
            }
          } else {
            txtMensjae = "El numero de contacto es obligatorio";
          }
        } else {
          txtMensjae = "El apellido es obligatorio";
        }
      } else {
        txtMensjae = "El nombre es obligatorio";
      }
    } else {
      txtMensjae = "No selecciono una categoria";
    }

    if (txtMensjae != "") {
      mensaje(txtMensjae);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MS24HS - Registro"),
        centerTitle: true,
        backgroundColor: Colors.yellow[600],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: Colors.red[400],
            label: Text("Cancelar"),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              registrarUsuario();
            },
            backgroundColor: Colors.green[400],
            label: Text("Crear cuenta"),
          ),
        ],
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
              child: Center(
                child: Text("Registro de usuario",
                    style: TextStyle(
                      fontSize: 28,
                    )),
              ),
            ),
            Container(
              child: SwitchListTile(
                  value: esProf,
                  title: Text(text),
                  onChanged: (bool value) {
                    setState(() {
                      esProf = value;
                      if (esProf) {
                        text = "Profesional";
                      } else {
                        text = "Usuario";
                      }
                    });
                  }),
            ),
            if (esProf) ...[
              //Si es profesional
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 20),
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
                            ),
                          ), //Categorias
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 20),
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
                          ), //Categorias
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Padding(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 20),
                            child: TextField(
                              controller: _nombreController,
                              decoration: const InputDecoration(
                                hintText: "Nombre",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: _apellidoController,
                              decoration:
                                  const InputDecoration(hintText: "Apellido"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
              ),
            ), //Nombre
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _celularController,
                  decoration: const InputDecoration(
                      hintText: "Numero de celular",
                      icon: Icon(Icons.numbers))),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  enabled: true,
                  controller: _emailController,
                  decoration: const InputDecoration(
                      hintText: "Correo electronico", icon: Icon(Icons.email))),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                  obscureText: true,
                  controller: _claveController,
                  decoration: const InputDecoration(
                      hintText: "Clave", icon: Icon(Icons.lock))),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                controller: _confirmarClaveController,
                decoration: const InputDecoration(
                    hintText: "Confirmar clave", icon: Icon(Icons.lock)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void iniciarSesion() async {
    await webService.WebService()
        .iniciarSesion(_emailController.text, _claveController.text)
        .then((String value) {
      if (value == "Ok") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Inicio(
                categoriasLista: widget.categorias,
                subCategoriaLista: widget.subCategorias,
              ),
            ),
            (route) => false);
      }
    });
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
}

// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ms24hs/models/categorias.dart';
import 'package:ms24hs/models/servicios.dart';
import 'package:ms24hs/models/subCategorias.dart';
import 'package:ms24hs/servicios.dart';
import 'package:ms24hs/varglobal.dart' as global;
import "package:http/http.dart" as http;
import 'package:ms24hs/provider/appBar.dart';
import 'package:ms24hs/service/sharedPreferences.dart';
import 'package:ms24hs/service/webService.dart';
import 'package:ms24hs/models/agenda.dart';
import "package:ms24hs/db/dataBase.dart";
import 'package:ms24hs/models/valores.dart';
import "package:ms24hs/provider/pantallaCarga.dart";
import 'package:image_picker/image_picker.dart';

class CrearServicio extends StatefulWidget {
  final List<Categorias> categoriasList;
  const CrearServicio({
    Key? key,
    required this.categoriasList,
  }) : super(key: key);

  @override
  State<CrearServicio> createState() => _CrearServicio();
}

final GlobalKey _ModalCarga = new GlobalKey();

class _CrearServicio extends State<CrearServicio> {
  final _tituloServicio = TextEditingController();
  final _contactoServicio = TextEditingController();
  final _descripcionServicio = TextEditingController();
  final ImagePicker _imagenServicio = ImagePicker();
  List<Categorias> categorias = [];
  List<SubCategorias> subCategorias = [];
  List<DatosVl> paises = [];
  Categorias? _catVal;
  SubCategorias? _subCatVal;
  DatosVl? _paisVal;
  DB _db = DB();
  var pathImg;
  File? imageFile;

  Datosservicios? datos;
  String actualizo = "N";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categorias = widget.categoriasList;
    _catVal = categorias[0];
    obtenerSubCategoria(_catVal!.idCategoria, false);
    getCountries();
  }

  Future<void> getCountries() async {
    List<DatosVl> listTemp = await _db.getPaises();
    //print(listTemp[0]);
    print(
        "/----------------------------------------- INICIO -----------------------------------------------/");
    listTemp.forEach((DatosVl datos) {
      print("---> " +
          datos.vlTpId.toString() +
          ' ' +
          datos.vlId.toString() +
          ' ' +
          datos.vlNombre.toString());
    });
    print(
        "/------------------------------------------- FIN ---------------------------------------------/");
    setState(() {
      paises = listTemp;
      _paisVal = paises[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: appBarMenu("- Crear servicio"),
      drawer: menuLateral(),
      // ignore: avoid_unnecessary_containers
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          child: ListView(
            scrollDirection: Axis.vertical,
            padding:
                const EdgeInsets.only(bottom: 25, top: 25, left: 10, right: 10),
            children: [
              Column(
                children: [
                  const Text(
                    "Nombre del servicio: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  TextField(
                      controller: _tituloServicio,
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Text(
                    "Seleccione una categoria: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  DropdownButton(
                    isExpanded: true,
                    items: categorias.map((Categorias item) {
                      return DropdownMenuItem(
                        child: Text(item.nombreCategoria,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(fontSize: 16)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (Categorias? c) {
                      setState(() {
                        obtenerSubCategoria(c!.idCategoria, true);
                        _catVal = c;
                      });
                    },
                    value: _catVal,
                  ), //Categoria
                ],
              ), //Categorias
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Text(
                    "Seleccione una sub categoria: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  DropdownButton(
                    isExpanded: true,
                    items: subCategorias.map((SubCategorias item) {
                      return DropdownMenuItem(
                        child: Text(item.subcatNombre,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(fontSize: 16)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (SubCategorias? c) {
                      setState(() {
                        _subCatVal = c;
                      });
                    },
                    value: _subCatVal,
                  ), //Sub Categoria
                ],
              ), //Sub Categorias
              Column(
                children: [
                  const Text(
                    "Numero de celular",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _contactoServicio,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Pais: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  DropdownButton(
                    isExpanded: true,
                    items: paises.map((DatosVl item) {
                      return DropdownMenuItem(
                        child: Text(item.vlNombre.toString(),
                            overflow: TextOverflow.clip,
                            style: const TextStyle(fontSize: 16)),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (DatosVl? c) {
                      setState(() {
                        _paisVal = c;
                      });
                    },
                    value: _paisVal,
                  ), //Paises
                ],
              ), //Paises
              Column(
                children: [
                  const Text(
                    "Descripcion",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    minLines: 1,
                    maxLines: 5000,
                    controller: _descripcionServicio,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Cargar Imagen",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  _ImagenView(),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          onPressed: () => pickImage(ImageSource.gallery),
                          child: Text("Seleccionar una foto"),
                        ),
                        RaisedButton(
                          onPressed: () => pickImage(ImageSource.camera),
                          child: Text("Tomar una foto"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    color: Colors.red[600],
                    onPressed: () async {
                      //Vuelve para atras
                      Navigator.of(context)
                          .pop('Ok'); //Vuelvo para atras, al admin de servicios
                    },
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.green[600],
                    onPressed: crearServicio,
                    child: const Text(
                      "Crear",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> crearServicio() async {
    String titulo = _tituloServicio.text;
    String contacto = _contactoServicio.text;
    String descripcion = _descripcionServicio.text;
    int idCategoria = _catVal!.idCategoria;
    int idSubCategoria = _subCatVal!.subcatId;
    int idPais = _paisVal!.vlId!.toInt();
    if (titulo.isNotEmpty) {
      if (contacto.isNotEmpty) {
        if (descripcion.isNotEmpty) {
          if (idCategoria > 0) {
            if (idPais > 0) {
              PantallaCarga.cargandoDatos(
                  context, _ModalCarga, "Creando servicio...");
              await WebService()
                  .createService(imageFile, titulo, contacto, descripcion,
                      idCategoria, idSubCategoria, idPais)
                  .then((int resultado) async {
                print("El resultado eeesss -------->  " + resultado.toString());
                if (resultado == 1) //Esta todo OK se subio correctamente
                {
                  /** Debo moverme a la pantalla de servicios */
                  await WebService()
                      .obtenerServicios()
                      .then((ServiciosWs value) {
                    Navigator.of(context).pop('Ok'); //para cerrar el cargando
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>
                                Servicios(serviciosList: value)),
                        (route) => false);
                  });
                }
              });
            }
          }
        }
      }
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return;
      }

      setState(() {
        imageFile = File(image.path);
      });
    } on PlatformException catch (e) {
      print("El error es el: --->   $e");
    }
  }

  Widget _ImagenView() {
    if (imageFile == null) {
      return const Center(
        child: Text("Seleccione una foto o tome una foto"),
      );
    } else {
      return Image.file(
        imageFile!,
      );
    }
  }

  Future<String> obtenerSubCategoria(
      int idCategoria, bool mostrarPantallaCarga) async {
    List<SubCategorias> subCat = [];
    if (mostrarPantallaCarga == true) {
      PantallaCarga.cargandoDatos(context, _ModalCarga, "");
    }
    subCat = await WebService().getSubCategory(idCategoria);
    setState(() {
      subCategorias = subCat;
      _subCatVal = subCategorias[0];
    });
    if (mostrarPantallaCarga == true) {
      Navigator.of(context).pop('Ok'); //para cerrar el cargando
    }
    return "Ok";
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

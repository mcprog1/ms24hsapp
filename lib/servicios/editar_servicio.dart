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

class EditarServicio extends StatefulWidget {
  final Datosservicios? datos;
  final List<Categorias> categoriasList;
  const EditarServicio({
    Key? key,
    required this.categoriasList,
    required this.datos,
  }) : super(key: key);

  @override
  State<EditarServicio> createState() => _EditarServicio();
}

final GlobalKey _ModalCarga = new GlobalKey();

class _EditarServicio extends State<EditarServicio> {
  final _tituloServicio = TextEditingController();
  final _contactoServicio = TextEditingController();
  final _descripcionServicio = TextEditingController();
  List<Categorias> categorias = [];
  List<SubCategorias> subCategorias = [];
  List<DatosVl> paises = [];
  Categorias? _catVal;
  SubCategorias? _subCatVal;
  DatosVl? _paisVal;
  DB _db = DB();
  int idServicio = 0;

  Datosservicios? datosServicio;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categorias = widget.categoriasList;
    datosServicio = widget.datos;
    idServicio = datosServicio!.id!;
    getCountries();
    cargarDatos();
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
      // _subCatVal = subCategorias[0];
    });
    if (mostrarPantallaCarga == true) {
      Navigator.of(context).pop('Ok'); //para cerrar el cargando
    }
    return "Ok";
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

  Future<void> cargarDatos() async {
    DatosVl? pais;
    Categorias? cat;
    SubCategorias? subCat;
    categorias.forEach((element) {
      if (datosServicio!.idCategoria == element.idCategoria) {
        cat = element;
      }
    });
    await obtenerSubCategoria(cat!.idCategoria, false);
    subCat = subCategorias[0];
    if (datosServicio!.idSubCategoria != 0) {
      subCategorias.forEach((element) {
        if (datosServicio!.idSubCategoria ==
            element.subcatCatId) //If this subcat selected
        {
          subCat = element;
        }
      });
    }

    for (var element in paises) {
      if (datosServicio!.idPais == element.vlId) //Si es el pais seleccionado
      {
        pais = element;
      }
    }
    setState(() {
      _tituloServicio.text = datosServicio!.nombre!;
      _contactoServicio.text = datosServicio!.numeroTelefono!;
      _descripcionServicio.text = datosServicio!.descripcionServicio!;
      _catVal = cat;
      _subCatVal = subCat;
      _paisVal = pais;
    });
    //Navigator.of(context).pop('Ok'); //para cerrar el cargando
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
                    controller: _descripcionServicio,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5000,
                    style: const TextStyle(fontSize: 16),
                  )
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
                    onPressed: actualizarServicio,
                    child: const Text(
                      "Actualizar",
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

  Future<void> actualizarServicio() async {
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
                  .actualizarServicio(idServicio, titulo, contacto, descripcion,
                      idCategoria, idSubCategoria, idPais)
                  .then((int? resultado) async {
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
}

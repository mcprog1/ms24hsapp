import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ms24hs/models/categorias.dart';
import 'package:ms24hs/models/subCategorias.dart';
import 'varglobal.dart' as global;
import 'provider/appBar.dart';
import 'service/sharedPreferences.dart';
import 'service/webService.dart';
import 'package:ms24hs/models/agenda.dart';
import "package:ms24hs/db/dataBase.dart";
import 'package:ms24hs/models/valores.dart';
import "package:ms24hs/provider/pantallaCarga.dart";
import 'provider/servicios.dart';
import 'package:ms24hs/models/servicios.dart';
import 'package:ms24hs/servicios/crear_servicio.dart';
import 'package:ms24hs/models/UbicacionServicio.dart';
import 'package:ms24hs/servicios/agregar_ubicacion.dart';
import 'package:ms24hs/servicios/editar_servicio.dart';

class Servicios extends StatefulWidget {
  final ServiciosWs? serviciosList;
  Servicios({
    required this.serviciosList,
    Key? key,
  }) : super(key: key);

  @override
  State<Servicios> createState() => _Servicios();
}

class _Servicios extends State<Servicios> {
  DB db = new DB();
  final GlobalKey _ModalCarga = new GlobalKey();
  final GlobalKey _ModalCarga1 = new GlobalKey();
  List<Categorias> _categorias = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerCategoria();
  }

  Future<void> obtenerCategoria() async {
    _categorias = await db.getCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMenu(" - Servicios"),
      drawer: menuLateral(),
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: const Text("Crear servicio"),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CrearServicio(
                                  categoriasList: _categorias,
                                )));
                  },
                ),
                const SizedBox(
                  width: 10.0,
                )
              ],
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: servicios(widget.serviciosList),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> servicios(ServiciosWs? servicios) {
    List<Widget> lista = [];
    int cantidad = 0;
    Widget fila;
    List<Widget> contenidoFila = [];

    List<Widget> lFila = [];
    servicios!.datosservicios!.forEach((element) {
      lista.add(adminServicio(context, element));
      /*contenidoFila.add(ServicioEstruc().adminServicio(context, element));
      cantidad++;
      if (cantidad > 1) {
        fila = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: contenidoFila,
        );
        lFila.add(fila);
        contenidoFila = [];
        cantidad = 0;
      }*/
    });

    return lista;
  }

  Widget adminServicio(BuildContext context, Datosservicios datos) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            // ignore: prefer_const_literals_to_create_immutables
                            child: Row(children: [
                              const Icon(Icons.gps_fixed),
                              const Text(" Ubicaciones"),
                            ]),
                            onTap: () async {
                              PantallaCarga.cargandoDatos(
                                  context, _ModalCarga, "");
                              await WebService()
                                  .getLocationService(datos.id!.toInt())
                                  .then((UbicacionServicios ubi) {
                                Navigator.of(context)
                                    .pop('Ok'); //para cerrar el cargando
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => Ubicaciones(
                                            ubicaciones: ubi,
                                            idServicio: datos.id,
                                          )),
                                );
                              });
                            },
                          ),
                          PopupMenuItem(
                            // ignore: prefer_const_literals_to_create_immutables
                            child: Row(children: [
                              const Icon(Icons.edit),
                              const Text(" Editar"),
                            ]),
                            onTap: () async {
                              PantallaCarga.cargandoDatos(
                                  context, _ModalCarga, "");
                              await WebService()
                                  .obtenerDatosServicio(datos.id!.toInt())
                                  .then((Datosservicios? datos) {
                                Navigator.of(context)
                                    .pop('Ok'); //para cerrar el cargando
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => EditarServicio(
                                          categoriasList: _categorias,
                                          datos: datos)),
                                );
                              });
                            },
                          ),
                          PopupMenuItem(
                            // ignore: prefer_const_literals_to_create_immutables
                            child: Row(children: [
                              const Icon(Icons.delete),
                              const Text(" Eliminar "),
                            ]),
                            onTap: () {
                              eliminarServicio(datos.id!);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Image.network(
                      'https://' +
                          global.baseUrl +
                          global.project +
                          global.imgUrl +
                          datos.urlImagen.toString(),
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
                            datos.nombre.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(padding: EdgeInsets.only(top: 6)),
                          Text(
                            datos.descripcionServicio.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ), //Titulo y descripcion del servicio
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> editarServicio(Datosservicios? datos) async {
    print("Entrooo acaaaa 2222222");
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditarServicio(
                datos: datos,
                categoriasList: _categorias,
              )),
    );
  }

  Future<void> eliminarServicio(int idServicio) async {
    int? resultado = await WebService().eliminarServicio(idServicio);
    if (resultado == 1) //Se agrego correctamente
    {
      await WebService().obtenerServicios().then((ServiciosWs value) {
        Navigator.of(context).pop('Ok'); //para cerrar el cargando
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Servicios(serviciosList: value)),
            (route) => false);
      });
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
}

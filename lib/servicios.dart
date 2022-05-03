import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
                  onPressed: () {},
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
      lista.add(ServicioEstruc().adminServicio(context, element));
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

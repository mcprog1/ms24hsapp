import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'varglobal.dart' as global;
import 'provider/appBar.dart';
import 'service/sharedPreferences.dart';
import 'service/webService.dart';
import "package:ms24hs/db/dataBase.dart";
import 'package:ms24hs/models/valores.dart';
import "package:ms24hs/provider/pantallaCarga.dart";
import 'package:ms24hs/models/reservas.dart';

class Reservas extends StatefulWidget {
  final ReservasWs reservas;
  const Reservas({
    Key? key,
    required this.reservas,
  }) : super(key: key);

  @override
  State<Reservas> createState() => _ReservasState();
}

class _ReservasState extends State<Reservas> {
  ReservasWs? datos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datos = widget.reservas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMenu("- Reservas"),
      drawer: menuLateral(),
      // ignore: avoid_unnecessary_containers
      body: Wrap(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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
                            'ID',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Servicio',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Estado',
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
                      rows: lineasReservas(datos),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<DataRow> lineasReservas(ReservasWs? datos) {
    List<DataRow> lista = [];
    datos!.datos!.forEach((element) {
      lista.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(element.idReserva.toString())),
            DataCell(Text(element.nombreServicio.toString())),
            DataCell(Text(element.estado.toString())),
            DataCell(Text("")),
          ],
        ),
      );
    });
    return lista;
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

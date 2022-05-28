import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ms24hs/models/categoriaslist.dart';
import 'package:ms24hs/models/usuario.dart';
import 'varglobal.dart' as global;
import 'provider/appBar.dart';
import 'service/sharedPreferences.dart';
import 'service/webService.dart';
import "package:ms24hs/db/dataBase.dart";
import "package:ms24hs/provider/pantallaCarga.dart";
import 'package:ms24hs/models/valores.dart';
import 'package:ms24hs/models/usuarios.dart';
import 'package:ms24hs/models/categorias.dart';
import 'package:ms24hs/models/solictudes.dart';

class Sistema extends StatefulWidget {
  Valores? paises;
  Usuarios? usuarios;
  Solicitudes? solicitudes;
  CategoriaList? categorias;
  Sistema({
    Key? key,
    this.categorias,
    this.paises,
    this.solicitudes,
    this.usuarios,
  }) : super(key: key);

  @override
  State<Sistema> createState() => _SistemaState();
}

class _SistemaState extends State<Sistema> {
  Valores? paises;
  Usuarios? usuarios;
  Solicitudes? solicitudes;
  CategoriaList? categorias;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paises = widget.paises;
    usuarios = widget.usuarios;
    solicitudes = widget.solicitudes;
    categorias = widget.categorias;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMenu("- Sistema"),
      drawer: menuLateral(),
      // ignore: avoid_unnecessary_containers
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              child: const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 5),
                child: Center(
                  child: Text(
                    "Datos del sistema",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        "Paises",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
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
                            'Pais',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Contacto',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Mail',
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
                      rows: lineasPaises(paises),
                    ),
                  )
                ],
              ),
            ), //Paises
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        "Usuarios",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
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
                            'Nombre',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Tipo usuario',
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
                      rows: lineasUsuarios(usuarios),
                    ),
                  )
                ],
              ),
            ), //Usuarios
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        "Solicitudes",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
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
                            'Nombre',
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
                        DataColumn(
                          label: Text(
                            '',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: lineasSolicitudes(solicitudes),
                    ),
                  )
                ],
              ),
            ), //Solicitudes
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        "Categorias",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
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
                            'Nombre',
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
                      rows: lineasCategorias(categorias),
                    ),
                  )
                ],
              ),
            ), //Categorias
          ],
        ),
      ),
    );
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

  List<DataRow> lineasPaises(Valores? paises) {
    List<DataRow> lista = [];
    paises!.datos!.forEach((element) {
      lista.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              element.vlNombre.toString(),
              textAlign: TextAlign.start,
            )),
            DataCell(Text(element.vlValor.toString())),
            DataCell(Text(element.vlValor1.toString())),
            DataCell(Text(""), showEditIcon: true, onTap: () async {
              //await cargarDatos(element);
              //modalAgenda(context);
            }),
          ],
        ),
      );
    });
    return lista;
  }

  List<DataRow> lineasUsuarios(Usuarios? usuarios) {
    List<DataRow> lista = [];
    usuarios!.listusuario!.forEach((element) {
      lista.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              element.idUsuario.toString(),
              textAlign: TextAlign.start,
            )),
            DataCell(Text(element.nombreUsuario.toString())),
            DataCell(Text(element.tipoUsuario.toString())),
            DataCell(Text(""), showEditIcon: false, onTap: () async {
              //await cargarDatos(element);
              //modalAgenda(context);
            }),
          ],
        ),
      );
    });
    return lista;
  }

  List<DataRow> lineasSolicitudes(Solicitudes? solicitudes) {
    List<DataRow> lista = [];
    solicitudes!.listasol!.forEach((element) {
      lista.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              element.idSolicitud.toString(),
              textAlign: TextAlign.start,
            )),
            DataCell(Text(element.nombreUsuario.toString())),
            DataCell(Text(element.estado.toString())),
            DataCell(Text(""), showEditIcon: false, onTap: () async {
              //await cargarDatos(element);
              //modalAgenda(context);
            }),
            DataCell(Text(""), showEditIcon: false, onTap: () async {
              //await cargarDatos(element);
              //modalAgenda(context);
            }),
          ],
        ),
      );
    });
    return lista;
  }

  List<DataRow> lineasCategorias(CategoriaList? categoriaList) {
    List<DataRow> lista = [];
    categoriaList!.listcat!.forEach((element) {
      lista.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              element.nombreCategoria.toString(),
              textAlign: TextAlign.start,
            )),
            DataCell(Text(""), showEditIcon: false, onTap: () async {
              //await cargarDatos(element);
              //modalAgenda(context);
            }),
          ],
        ),
      );
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
}

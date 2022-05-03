// ignore_for_file: deprecated_member_use

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

class Agenda extends StatefulWidget {
  final AgendaWs? agendaList;
  const Agenda({
    Key? key,
    required this.agendaList,
  }) : super(key: key);

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  //String dia = "Lunes";
  DB db = new DB(); // Instancio la base de datos
  final GlobalKey _ModalCarga = new GlobalKey();
  final GlobalKey _ModalCarga1 = new GlobalKey();
  List<DatosVl> dias = [];
  List<DatosVl> horas = [];
  DatosVl dia = DatosVl();
  DatosVl desde = DatosVl();
  DatosVl hasta = DatosVl();
  AgendaWs? agendalista;
  @override
  void initState() {
    // TODO: implement initState
    obtenerDiasHoras();
    agendalista = widget.agendaList;
    super.initState();
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

  Future<void> obtenerDiasHoras() async {
    List<DatosVl> datosTemp = await db.getDias();
    List<DatosVl> datosHorasTemp = await db.getHoras();
    setState(() {
      dias = datosTemp;
      dia = datosTemp[0];
      horas = datosHorasTemp;
      desde = datosHorasTemp[0];
      hasta = datosHorasTemp[0];
    });
    print(dias[0]);
    print(dias.length);
    print(horas[0]);
    print(horas.length);
    print(desde);
    print(hasta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMenu("- Agenda"),
      drawer: menuLateral(),
      // ignore: avoid_unnecessary_containers
      body: Wrap(
        children: [
          /* Padding(
            padding: const EdgeInsets.all(40),
            // ignore: avoid_unnecessary_containers
            // ignore: prefer_const_literals_to_create_immutables
            child: Row(children: [
              const Expanded(
                child: Text(
                  "Agenda",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ]),
          ),*/
          // ignore: avoid_unnecessary_containers
          Container(
            child: Column(
              children: [
                Container(
                  //padding: const EdgeInsets.only(left: 10, right: 10),
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
                            'Dia',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Desde',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Hasta',
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
                      rows: lineasAgenda(agendalista),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> lineasAgenda(AgendaWs? agenda) {
    List<DataRow> lista = [];
    agenda!.datosAgenda!.forEach((element) {
      lista.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(
              element.dia.toString(),
              textAlign: TextAlign.start,
            )),
            DataCell(Text(element.desde.toString())),
            DataCell(Text(element.hasta.toString())),
            DataCell(Text(""), showEditIcon: true, onTap: () async {
              await cargarDatos(element);
              modalAgenda(context);
            }),
          ],
        ),
      );
    });
    return lista;
  }

  Future<void> cargarDatos(DatosAgenda element) async {
    dias.forEach((elementDia) {
      if (elementDia.vlId == element.iDia) {
        setState(() {
          dia = elementDia;
        });
      }
    });

    horas.forEach((elementHora) {
      if (elementHora.vlId == element.idDesde) {
        setState(() {
          desde = elementHora;
        });
      }
    });

    horas.forEach((elementHora) {
      if (elementHora.vlId == element.idHasta) {
        setState(() {
          hasta = elementHora;
        });
      }
    });
  }

  Future<void> recargarDatos() async {
    PantallaCarga.cargandoDatos(context, _ModalCarga, "");
    AgendaWs? agenda = await WebService().obtenerAgenda();
    setState(() {
      agendalista = agenda;
    });
    Navigator.of(context).pop('Ok'); //para cerrar el modal
  }

  void modalAgenda(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
              ),
              title: Container(
                child: const Text(
                  "Agenda",
                  textAlign: TextAlign.center,
                ),
              ),
              content: Wrap(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Wrap(
                    children: [
                      // ignore: prefer_const_constructors
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: const Text(
                          "Dia",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Card(
                        elevation: 3,
                        child: StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter dropDownState) {
                            return DropdownButton(
                                value: dia,
                                isExpanded: true,
                                underline:
                                    const Padding(padding: EdgeInsets.all(5)),
                                alignment: Alignment.center,
                                items: dias.map<DropdownMenuItem<DatosVl>>(
                                    (DatosVl value) {
                                  return DropdownMenuItem<DatosVl>(
                                    value: value,
                                    child: Text(value.vlNombre.toString(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center),
                                  );
                                }).toList(),
                                onChanged: (DatosVl? value) {
                                  dropDownState(() {
                                    dia = value!;
                                  });
                                });
                          },
                        ),
                      ), // Dia
                      // ignore: prefer_const_constructors
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: const Text(
                          "Desde",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Card(
                        elevation: 3,
                        child: StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter dropDownState) {
                            return DropdownButton(
                                value: desde,
                                isExpanded: true,
                                underline:
                                    const Padding(padding: EdgeInsets.all(5)),
                                alignment: Alignment.center,
                                items: horas.map<DropdownMenuItem<DatosVl>>(
                                    (DatosVl value) {
                                  return DropdownMenuItem<DatosVl>(
                                    value: value,
                                    child: Text(value.vlNombre.toString(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center),
                                  );
                                }).toList(),
                                onChanged: (DatosVl? value) {
                                  dropDownState(() {
                                    desde = value!;
                                  });
                                });
                          },
                        ),
                      ), // Desde
                      // ignore: prefer_const_constructors
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: const Text(
                          "Hasta",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Card(
                        elevation: 3,
                        child: StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter dropDownState) {
                            return DropdownButton(
                                value: hasta,
                                isExpanded: true,
                                underline:
                                    const Padding(padding: EdgeInsets.all(5)),
                                alignment: Alignment.center,
                                items: horas.map<DropdownMenuItem<DatosVl>>(
                                    (DatosVl value) {
                                  return DropdownMenuItem<DatosVl>(
                                    value: value,
                                    child: Text(value.vlNombre.toString(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center),
                                  );
                                }).toList(),
                                onChanged: (DatosVl? value) {
                                  dropDownState(() {
                                    hasta = value!;
                                  });
                                });
                          },
                        ),
                      ), // Hasta
                    ],
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop('Ok'); //para cerrar el modal
                      },
                      child: Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        PantallaCarga.cargandoDatos(context, _ModalCarga1, "");
                        int? idDia = dia.vlId;
                        int? idDesde = desde.vlId;
                        int? idHasta = hasta.vlId;
                        int? code = await WebService()
                            .guardarAgenda(idDia, idDesde, idHasta);
                        Navigator.of(context)
                            .pop('Ok'); //para cerrar el cargando
                        if (code == 0) {
                          Navigator.of(context)
                              .pop('Ok'); //para cerrar el modal
                          recargarDatos();
                        }
                      },
                      child: Text("Actualizar"),
                    ),
                  ],
                ),
              ], //Botones de accion
            ));
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

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ms24hs/varglobal.dart' as global;
import 'package:ms24hs/inicio.dart';
import 'package:ms24hs/agenda.dart';
import 'package:ms24hs/service/webService.dart';
import 'package:ms24hs/models/agenda.dart';

PreferredSizeWidget? appBarMenu() {
  if (global.logeado) {
    return AppBar(
      centerTitle: true,
      backgroundColor: global.colorFondo,
      title: Text("MS24HS"),
    );
  } else {
    return null;
  }
}

Widget? listadoMenu(BuildContext context) {
  return ListView(
    children: [
      ListTile(
        title: const Text(
          "Inicio",
        ),
        onTap: () {},
      ),
      ListTile(
        title: const Text(
          "Agenda",
        ),
        onTap: () async {
          if (global.usaWs == "S") {
            await WebService().obtenerAgenda().then((AgendaWs value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Agenda(
                            agendaList: value,
                          )),
                  (route) => false);
            });
          } else {
            AgendaWs agenda = AgendaWs();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Agenda(
                          agendaList: agenda,
                        )),
                (route) => false);
          }
        },
      ),
      ListTile(
        title: const Text(
          "Mis servicios",
        ),
        onTap: () {
          /*Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Agenda()),
              (route) => false);*/
        },
      ),
      ListTile(
        title: const Text(
          "Pagos",
        ),
        onTap: () {
          /*Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Agenda()),
              (route) => false);*/
        },
      ),
      ListTile(
        title: const Text(
          "Reservas",
        ),
        onTap: () {
          /*Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Agenda()),
              (route) => false);*/
        },
      ),
      ListTile(
        title: const Text(
          "Sistema",
        ),
        onTap: () {
          /*Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Agenda()),
              (route) => false);*/
        },
      ),
      ListTile(
        title: const Text(
          "Configuracion",
        ),
        onTap: () {
          /*Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Agenda()),
              (route) => false);*/
        },
      ),
    ],
  );
}

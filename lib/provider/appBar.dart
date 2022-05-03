// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ms24hs/varglobal.dart' as global;
import 'package:ms24hs/inicio.dart';
import 'package:ms24hs/agenda.dart';
import 'package:ms24hs/servicios.dart';
import 'package:ms24hs/service/webService.dart';
import 'package:ms24hs/models/agenda.dart';
import 'package:ms24hs/models/servicios.dart';
import 'package:ms24hs/provider/pantallaCarga.dart';

final GlobalKey _ModalCarga = new GlobalKey();

PreferredSizeWidget? appBarMenu(String? titulo) {
  String title = "MS24HS";
  if (titulo!.isNotEmpty) {
    title = title + " " + titulo.toString();
  }
  if (global.logeado) {
    return AppBar(
      centerTitle: true,
      backgroundColor: global.colorFondo,
      title: Text(title),
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
        onTap: () {
          PantallaCarga.cargandoDatos(context, _ModalCarga, "");
        },
      ),
      ListTile(
        title: const Text(
          "Agenda",
        ),
        onTap: () async {
          PantallaCarga.cargandoDatos(context, _ModalCarga, "");
          await WebService().obtenerAgenda().then((AgendaWs value) {
            Navigator.of(context).pop('Ok'); //para cerrar el cargando
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Agenda(
                          agendaList: value,
                        )),
                (route) => false);
          });
        },
      ),
      ListTile(
        title: const Text(
          "Mis servicios",
        ),
        onTap: () async {
          PantallaCarga.cargandoDatos(context, _ModalCarga, "");
          await WebService().obtenerServicios().then((ServiciosWs value) {
            Navigator.of(context).pop('Ok'); //para cerrar el cargando
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Servicios(serviciosList: value)),
                (route) => false);
          });
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

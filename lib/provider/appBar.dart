// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ms24hs/models/categorias.dart';
import 'package:ms24hs/models/categoriaslist.dart';
import 'package:ms24hs/models/pagos.dart';
import 'package:ms24hs/models/solictudes.dart';
import 'package:ms24hs/models/subCategorias.dart';
import 'package:ms24hs/models/usuarios.dart';
import 'package:ms24hs/models/valores.dart';
import 'package:ms24hs/varglobal.dart' as global;
import 'package:ms24hs/inicio.dart';
import 'package:ms24hs/agenda.dart';
import 'package:ms24hs/servicios.dart';
import 'package:ms24hs/sistema.dart';
import 'package:ms24hs/pagos.dart';
import 'package:ms24hs/reservas.dart';
import 'package:ms24hs/service/webService.dart';
import 'package:ms24hs/models/agenda.dart';
import 'package:ms24hs/models/servicios.dart';
import 'package:ms24hs/provider/pantallaCarga.dart';
import 'package:ms24hs/models/reservas.dart';

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
  int tipoUsuario = global.datosUsuario!.tipoUsuario!;
  return ListView(
    children: [
      ListTile(
        title: const Text(
          "Inicio",
        ),
        onTap: () async {
          PantallaCarga.cargandoDatos(context, _ModalCarga, "");
          List<Categorias> categorias = await WebService().getCategory();
          List<SubCategorias> subCategorias =
              await WebService().getSubCategory(categorias[0].idCategoria);
          Navigator.of(context).pop('Ok'); //para cerrar el cargando
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Inicio(
                        categoriasLista: categorias,
                        subCategoriaLista: subCategorias,
                      )),
              (route) => false);
        },
      ),
      if (global.datosUsuario!.tipoUsuario == 2) ...[
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
      ],
      if (global.datosUsuario!.tipoUsuario == 3) ...[
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
      ],
      ListTile(
        title: const Text(
          "Pagos",
        ),
        onTap: () async {
          PantallaCarga.cargandoDatos(context, _ModalCarga, "");
          await WebService().obtenerPagos().then((PagosWs? datos) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Pagos(
                          pagos: datos!,
                        )),
                (route) => false);
          });
        },
      ),
      ListTile(
        title: const Text(
          "Reservas",
        ),
        onTap: () async {
          PantallaCarga.cargandoDatos(context, _ModalCarga, "");
          await WebService().obtenerReservas().then((ReservasWs datos) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Reservas(
                          reservas: datos,
                        )),
                (route) => false);
          });
        },
      ),
      if (global.datosUsuario!.tipoUsuario == 3) ...[
        ListTile(
          title: const Text(
            "Sistema",
          ),
          onTap: () async {
            PantallaCarga.cargandoDatos(context, _ModalCarga, "");
            Valores? p;
            Usuarios? u;
            Solicitudes? s;
            CategoriaList? c;
            //Primero cargo los paises
            await WebService().obtenerPaises().then((Valores? dat) {
              p = dat;
            });
            //Despues cargo los usuarios
            await WebService().obtenerUsuarios().then((Usuarios? dat) {
              u = dat;
            });
            //Despues cargo las solicitudes
            await WebService().obtenerSolicitudes().then((Solicitudes? dat) {
              s = dat;
            });
            //Cargo las categorias
            await WebService()
                .obtenerCategoriasLista()
                .then((CategoriaList? dat) {
              c = dat;
            });
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Sistema(
                          categorias: c,
                          paises: p,
                          solicitudes: s,
                          usuarios: u,
                        )),
                (route) => false);
          },
        ),
      ],
      /*ListTile(
        title: const Text(
          "Configuracion",
        ),
        onTap: () {
          /*Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Agenda()),
              (route) => false);*/
        },
      ),*/
    ],
  );
}

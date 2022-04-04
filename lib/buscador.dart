// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import "inicio.dart";

import "varglobal.dart" as global;
import 'provider/splashScree.dart' as splash;
import 'provider/servicios.dart';

import 'models/subCategorias.dart';
import "models/categorias.dart";
import 'models/busqueda.dart';

class Buscador extends StatefulWidget {
  final Busqueda busqueda;
  const Buscador({
    Key? key,
    required this.busqueda,
  }) : super(key: key);

  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  List<Widget> listadoResultado(Busqueda resultado) {
    List<Widget> lista = [];
    resultado.datosBusqueda!.forEach((element) {
      lista.add(ServicioEstruc().mostrarServicio(
          context,
          element.urlImagen.toString(),
          element.nombreServicio.toString(),
          element.descripcionServicio.toString()));
    });
    return lista;
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
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
      body: Container(
        color: global.fondoGris,
        alignment: Alignment.center,
        child: ListView(scrollDirection: Axis.vertical, children: [
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: listadoResultado(widget.busqueda),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

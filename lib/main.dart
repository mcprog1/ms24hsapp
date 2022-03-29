import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import "varglobal.dart" as global;
import "models/categorias.dart";

import "inicio.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //Colocar future builder para obtener las categorias y despues redenrizar el MaterialApp
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: obtenerCategoriaLista(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Categorias>> snapshot) {
        if (snapshot.hasData && snapshot.data != []) {
          return MaterialApp(
            title: 'MS24HS',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Inicio(categoriasLista: snapshot.data!),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<Categorias>> obtenerCategoriaLista() async {
    List<Categorias> data = [];
    data.add(Categorias(
        idCategoria: 0,
        nombreCategoria: "Seleccione una categorias",
        urlImagen: "",
        tipoCategoria: 0,
        vigente: ""));
    Uri url = Uri.https(
        global.baseUrl, global.project + global.wsUrl + "ws/categoria/obtener");
    await http
        .get(url, headers: {"Accept": "application/json"}).then((respuesta) {
      String body = utf8.decode(respuesta.bodyBytes);
      var datos = jsonDecode(body);
      for (var item in datos["categorias"]) {
        data.add(Categorias(
            idCategoria: item["idCategoria"],
            nombreCategoria: item["nombreCategoria"],
            urlImagen: item["urlImagen"],
            tipoCategoria: item["tipoCategoria"],
            vigente: item["vigente"]));
      }
      return data;
    });
    return data;
  }
}

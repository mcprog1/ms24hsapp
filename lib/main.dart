import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:ms24hs/models/subCategorias.dart';
import "varglobal.dart" as global;
import "models/categorias.dart";
import 'provider/splashScree.dart' as splash;
import "inicio.dart";
import 'buscador.dart';

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
          return FutureBuilder(
            future: obtenerSubCategorias(snapshot.data![0]),
            builder: (BuildContext context,
                AsyncSnapshot<List<SubCategorias>> snapshotSub) {
              if (snapshotSub.hasData && snapshotSub.data != []) {
                print(snapshotSub.data![0].subcatNombre);
                return MaterialApp(
                  title: 'MS24HS',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: Inicio(
                      categoriasLista: snapshot.data!,
                      subCategoriaLista: snapshotSub.data!),
                  /*initialRoute: "/",
                      routes: {
                      },*/
                );
              } else {
                return splash.Splash().splash(context);
              }
            },
          );
        } else {
          return splash.Splash().splash(context);
          //Center(child: CircularProgressIndicator());
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

  Future<List<SubCategorias>> obtenerSubCategorias(Categorias categoria) async {
    List<SubCategorias> data = [];
    data.add(SubCategorias(
        subcatCatId: 0,
        subcatId: 0,
        subcatNombre: "Seleccione una sub categorias",
        subcatVigente: ""));
    Uri url = Uri.https(
        global.baseUrl,
        global.project + global.wsUrl + "ws/subCategoria/obtener",
        {"idCategoria": categoria.idCategoria.toString()});
    await http
        .get(url, headers: {"Accept": "application/json"}).then((respuesta) {
      String body = utf8.decode(respuesta.bodyBytes);
      var datos = jsonDecode(body);
      for (var item in datos) {
        data.add(SubCategorias(
            subcatId: item["subcat_id"],
            subcatCatId: item["subcat_cat_id"],
            subcatNombre: item["subcat_nombre"]));
      }
    });
    return data;
  }
}

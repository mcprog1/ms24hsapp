import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import "varglobal.dart" as global;
import "models/categorias.dart";

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  String _subCategoriaLabel = "Seleccione una sub-categoría";
  String _subCategoria = "Seleccione una categoría";

  List<Categorias> categoriasLista = [];
  //String _categoriaBusqueda = "6";
  Categorias _catVal = Categorias(
      idCategoria: 5,
      nombreCategoria: "Prueba Categoria",
      urlImagen: "public\/7n5xVXXpkkvCA52jk10H0TZiZ2HDRqiUJb5VHDL3.jpg",
      tipoCategoria: 1,
      vigente: "S");

  Future<String> obtenerCategoriaLista() async {
    Uri url = Uri.https(
        global.baseUrl, global.project + global.wsUrl + "ws/categoria/obtener");
    await http
        .get(url, headers: {"Accept": "application/json"}).then((respuesta) {
      String body = utf8.decode(respuesta.bodyBytes);
      var datos = jsonDecode(body);
      List<Categorias> data = [];
      for (var item in datos["categorias"]) {
        data.add(Categorias(
            idCategoria: item["idCategoria"],
            nombreCategoria: item["nombreCategoria"],
            urlImagen: item["urlImagen"],
            tipoCategoria: item["tipoCategoria"],
            vigente: item["vigente"]));
      }
      setState(() {
        categoriasLista = data;
      });
    });
    return "Listo";
  }

  @override
  void initState() {
    super.initState();
    obtenerCategoriaLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.yellow[600],
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/img/logo-sos.png",
                  width: MediaQuery.of(context).size.width / 2,
                  height: 200,
                ),
              ), //Imagen de la empresa
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),

              DropdownButton(
                value: _catVal,
                items: categoriasLista.map((Categorias item) {
                  // ignore: unnecessary_new
                  return new DropdownMenuItem(
                    child: Text(item.nombreCategoria),
                    value: item,
                  );
                }).toList(),
                onChanged: (c) {},
              ),

              Container(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 4.1,
                              right: MediaQuery.of(context).size.width / 4.1),
                          // ignore: prefer_const_constructors
                          child: TextField(
                            // ignore: prefer_const_constructors
                            decoration: InputDecoration(
                                hintText: "Ingrese su localidad"),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ), //Inputs
              Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              RaisedButton.icon(
                //shape: CircleBorder(),
                onPressed: () {
                  print("Apreto el boton");
                },
                color: Colors.green[600],
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                label: Text(
                  "Buscar",
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ), //Icon(Icons.search, color: Colors.black87,),
              ), //Botón de busqueda,
              /*Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 2.4,
                    right: MediaQuery.of(context).size.width / 2.4),
                child: Expanded(
                    child: Divider(
                  color: Colors.black87,
                )),
              ),*/
              Padding(padding: EdgeInsets.only(top: 10)),
              ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Wrap(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextField(),
                                    TextField(),
                                    TextField(),
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text("Iniciar Sesion",
                      style: TextStyle(color: Colors.white, fontSize: 21))),
              Padding(padding: EdgeInsets.only(top: 10)),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [],
                        );
                      });
                },
                child: Text("Crear cuenta",
                    style: TextStyle(color: Colors.white, fontSize: 21)),
                style: ButtonStyle(),
              )
            ],
          ),
        ],
      ),
    ));
  }
}

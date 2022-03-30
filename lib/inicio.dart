import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import "package:http/http.dart" as http;
import "varglobal.dart" as global;
import 'provider/modal.dart' as modales;
import "models/categorias.dart";
import "models/subCategorias.dart";
import 'package:rflutter_alert/rflutter_alert.dart';

class Inicio extends StatefulWidget {
  final List<Categorias> categoriasLista;
  final List<SubCategorias> subCategoriaLista;
  const Inicio(
      {Key? key,
      required this.categoriasLista,
      required this.subCategoriaLista})
      : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  String _subCategoriaLabel = "Seleccione una sub-categoría";
  String _subCategoria = "Seleccione una categoría";
  Categorias? _catVal;
  SubCategorias? _subCatVal;
  List<Categorias> catList = [];
  List<SubCategorias> subCatList = [];

  bool esProf = false;

  @override
  void initState() {
    super.initState();
    _catVal = widget.categoriasLista[0];
    catList = widget.categoriasLista;
    subCatList = widget.subCategoriaLista;
    _subCatVal = widget.subCategoriaLista[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
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
              const Padding(
                padding: const EdgeInsets.only(top: 10),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                margin: const EdgeInsets.all(10),
                child: DropdownButton(
                  items: catList.map((Categorias item) {
                    return DropdownMenuItem(
                      child: Text(item.nombreCategoria,
                          style: const TextStyle(fontSize: 13)),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (Categorias? c) {
                    setState(() {
                      obtenerSubCategoria(c!.idCategoria);
                      _catVal = c;
                    });
                  },
                  value: _catVal,
                ),
              ), //Categorias
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                margin: EdgeInsets.all(10),
                child: DropdownButton(
                  items: subCatList.map((SubCategorias item) {
                    return DropdownMenuItem(
                      child: Text(item.subcatNombre,
                          style: TextStyle(fontSize: 13)),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (SubCategorias? c) {
                    setState(() {
                      _subCatVal = c;
                    });
                  },
                  value: _subCatVal,
                ),
              ), //Sub categorias
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
              const Padding(
                padding: const EdgeInsets.only(top: 30),
              ),
              RaisedButton.icon(
                //shape: CircleBorder(),
                onPressed: () {
                  print("Apreto el boton");
                },
                color: Colors.green[600],
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                label: const Text(
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
              const Padding(padding: const EdgeInsets.only(top: 10)),
              ElevatedButton(
                  onPressed: () =>
                      modalRegistroLogin(this.context, "L", esProf).show(),
                  child: const Text("Iniciar Sesion",
                      style: TextStyle(color: Colors.white, fontSize: 21))),
              const Padding(padding: const EdgeInsets.only(top: 10)),
              ElevatedButton(
                onPressed: () =>
                    modalRegistroLogin(this.context, "R", esProf).show(),
                child: const Text("Crear cuenta",
                    style: const TextStyle(color: Colors.white, fontSize: 21)),
                style: const ButtonStyle(),
              )
            ],
          ),
        ],
      ),
    ));
  }

  Alert modalLoginRegistro(BuildContext context, String tipo) {
    return Alert(context: context, title: "Prueba");
  }

  Future<String> obtenerSubCategoria(int idCategoria) async {
    List<SubCategorias> subCat = [];
    Uri url = Uri.https(
        global.baseUrl,
        global.project + global.wsUrl + "ws/subCategoria/obtener",
        {"idCategoria": idCategoria.toString()});
    await http
        .get(url, headers: {"Accept": "application/json"}).then((respuesta) {
      String body = utf8.decode(respuesta.bodyBytes);
      var datos = jsonDecode(body);
      for (var item in datos) {
        subCat.add(SubCategorias(
            subcatId: item["subcat_id"],
            subcatCatId: item["subcat_cat_id"],
            subcatNombre: item["subcat_nombre"]));
      }
      print(subCat.length);
      setState(() {
        subCatList = subCat;
      });
    });
    return "Ok";
  }

  Alert modalRegistroLogin(BuildContext context, String tipo, bool esProf) {
    String titulo = "Registro";
    if (tipo == "L") //Es login
    {
      titulo = "Iniciar sesion";
    }
    Widget contenido = Column(
      /**
       * 
       * 
        if(true) ... [

        ],
       */
      children: [
        FlutterSwitch(
          activeText: "All Good. Negative.",
          inactiveText: "Under Quarantine.",
          value: esProf,
          valueFontSize: 10.0,
          width: 110,
          borderRadius: 30.0,
          showOnOff: true,
          onToggle: (val) {
            setState(() {
              esProf = val;
            });
          },
        ),
        TextField(
            decoration: InputDecoration(
          hintText: "Nombre",
        )),
        TextField(decoration: InputDecoration(hintText: "Apellido")),
        TextField(decoration: InputDecoration(hintText: "Cod cel")),
        TextField(
            decoration: InputDecoration(
                hintText: "Numero de celular", icon: Icon(Icons.numbers))),
        TextField(
            decoration: InputDecoration(
                hintText: "Correo electronico", icon: Icon(Icons.email))),
        TextField(
            decoration:
                InputDecoration(hintText: "Clave", icon: Icon(Icons.lock))),
        TextField(
          decoration: InputDecoration(
              hintText: "Confirmar clave", icon: Icon(Icons.lock)),
        ),
      ],
    );
    DialogButton cancelar = DialogButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        "Cancelar",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
    DialogButton accionBoton = DialogButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        "Registrarse",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );

    if (tipo == "L") {
      accionBoton = DialogButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          "Iniciar sesion",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
      contenido = Column(
        children: [
          TextField(
              decoration: InputDecoration(
                  hintText: "Correo electronico", icon: Icon(Icons.email))),
          TextField(
              decoration:
                  InputDecoration(hintText: "Clave", icon: Icon(Icons.lock))),
        ],
      );
    }

    return Alert(
        context: context,
        title: titulo,
        content: contenido,
        buttons: [accionBoton, cancelar]);
  }
}

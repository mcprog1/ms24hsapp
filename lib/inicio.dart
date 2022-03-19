import 'package:flutter/material.dart';


class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  var _listaCategoria = ["Albañil","Carpintero","Etc"];
  String _categoriaLabel = "Seleccione una categoría";
  String _subCategoriaLabel = "Seleccione una sub-categoría";

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
                  child: Image.asset("assets/img/logo-sos.png", 
                  width: MediaQuery.of(context).size.width/2,
                  height: 200,
                  ),
                ), //Imagen de la empresa
                Padding(
                  padding: EdgeInsets.only(top:50),
                ),
                Container(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          DropdownButton(
                            items: _listaCategoria.map((String e){
                              return DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              );
                            }).toList(), 
                            hint: Text(_categoriaLabel),
                            onChanged: (_value) => {
                              setState((){
                                _categoriaLabel = _value.toString();
                              })
                            }
                          ),
                          DropdownButton(
                            items: null, 
                            hint: Text(_subCategoriaLabel),
                            onChanged: (_value) => {
                              setState((){
                                _subCategoriaLabel = _value.toString();
                              })
                            }
                          ),
                          TextField(
                            decoration: InputDecoration(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),//Inputs
                Padding(
                  padding: EdgeInsets.only(top:30),
                ),
                RaisedButton.icon(
                  //shape: CircleBorder(), 
                  onPressed: () { print("Apreto el boton"); },
                  color: Colors.green[600],
                  icon: Icon(Icons.search, color: Colors.white,),
                  label: Text("Buscar", style: TextStyle(color: Colors.white,fontSize: 21),), //Icon(Icons.search, color: Colors.black87,),
                ) //Botón de busqueda,
              ],
            ),
          ],
        ),

      )
    );
  }
}

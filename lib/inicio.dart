import 'package:flutter/material.dart';


class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

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
                ),
                RaisedButton(
                  shape: CircleBorder(), 
                  onPressed: () {  },
                  color: Colors.red,
                  child: Text("Buscar"), //Icon(Icons.search, color: Colors.black87,),
                ),
              ],
            ),
          ],
        ),

      )
    );
  }
}

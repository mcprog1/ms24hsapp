import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import "package:flutter_switch/flutter_switch.dart";

class Modales {
  /* Alert modalRegistroLogin(BuildContext context, String tipo, bool esProf) {
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
  }*/
}

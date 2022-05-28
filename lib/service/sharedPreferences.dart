import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ms24hs/models/usuario.dart';

class SharedPreferencesService {
  SharedPreferences? preferences;

  Future<SharedPreferences> iniciarPreferencias() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setCargaDatos() async {
    preferences = await iniciarPreferencias();
    String refreshDate = await getCargaDatos();
    if (refreshDate == "S") {
      DateTime now = new DateTime.now();
      DateTime dateNow = new DateTime(now.year, now.month,
          now.day); //Obtengo la fecha de hoy para saber cuando se obtuvo por ultima ves los datos
      await preferences?.setString("cargoWs", dateNow.toString());
    }
  }

  Future<String> getCargaDatos() async {
    preferences = await iniciarPreferencias();
    String? result = await preferences?.getString("cargoWs");
    print("Aca cargoWS");
    print(result);
    String respuesta = "S";
    if (result != null) //Is not empty
    {
      respuesta = "N";
      DateTime now = DateTime.now();
      DateTime dateCharge = DateTime.parse(result);
      if (now.difference(dateCharge).inDays >
          2) //Si paso dos dias recien ahi actualizo de nuevo
      {
        respuesta = "S";
      }
    }
    return respuesta;
  }

  Future<void> setLogin(String datos) async {
    preferences = await iniciarPreferencias();
    await preferences?.setString("datosUsuario", datos);
  }

  Future<Datos?> getLogin() async {
    preferences = await iniciarPreferencias();
    String? result = await preferences?.getString("datosUsuario");
    Map<String, dynamic> decoded = jsonDecode('{"vacio":"vacio"}');
    if (result != null) {
      decoded = jsonDecode(result);
    }
    Datos? datos = Datos.fromJson(decoded);
    return datos;
  }

  Future<bool> cerrarSesion() async {
    preferences = await iniciarPreferencias();
    return preferences!.remove("datosUsuario");
  }
}

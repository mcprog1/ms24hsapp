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

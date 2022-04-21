import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:ms24hs/varglobal.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ms24hs/service/sharedPreferences.dart';
/** MODELOS */
import "package:ms24hs/models/usuario.dart";
import 'package:ms24hs/models/agenda.dart';
import 'package:ms24hs/models/tipo.dart';
import 'package:ms24hs/models/valores.dart';

class WebService {
  final client = Client();
  final prefs = SharedPreferences.getInstance();
  final urls = global.project + global.wsUrl + "ws/";

  Future<String> iniciarSesion(String email, String clave) async {
    Uri request = Uri.https(global.baseUrl, urls + "inicioSesion",
        {"email": email, "clave": clave});
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    Usuario result = Usuario.fromJson(jsonDecode(bodyByte));
    if (result.codigo == 0) //Todo Ok
    {
      var datos = jsonEncode(result.datos!.toJson());
      SharedPreferencesService().setLogin(datos);
      return "Ok";
    } else {
      return result.mensaje.toString();
    }
  }

  Future<AgendaWs> obtenerAgenda() async {
    AgendaWs agenda;
    Datos? datosUsuario = global.datosUsuario;
    int? idUsuario = datosUsuario?.idUsuario;

    Uri request = Uri.https(
        global.baseUrl, urls + "agenda/obtener", {"idUsuario": idUsuario});
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    agenda = AgendaWs.fromJson(jsonDecode(bodyByte));
    return agenda;
  }

  Future<Tipo> obtenerTipos() async {
    return null;
  }

  Future<Valores> obtenerValores() async {
    return null;
  }
}

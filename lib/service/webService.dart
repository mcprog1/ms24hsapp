import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:ms24hs/varglobal.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ms24hs/service/sharedPreferences.dart';
import 'package:ms24hs/db/dataBase.dart';
/** MODELOS */
import "package:ms24hs/models/usuario.dart";
import 'package:ms24hs/models/agenda.dart';
import 'package:ms24hs/models/tipo.dart';
import 'package:ms24hs/models/valores.dart';

class WebService {
  final client = Client();
  final DB db = new DB();
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
    print("getAgenda");
    Uri request = Uri.https(global.baseUrl, urls + "agenda/obtener",
        {"idUsuario": idUsuario.toString()});
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    agenda = AgendaWs.fromJson(jsonDecode(bodyByte));
    print(agenda.datosAgenda!.length);
    return agenda;
  }

  Future<void> cargarTipos() async {
    Uri request = Uri.https(global.baseUrl, urls + "obtenerTipo");
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    var datos = jsonDecode(bodyByte);
    Tipo tipo = Tipo.fromJson(datos);

    if (tipo.datos != null) {
      if (!tipo.datos!.isEmpty) {
        if (tipo.datos!.length > 0) {
          await db.eliminarTipo();
          for (var i = 0; i < tipo.datos!.length; i++) {
            print("Insert tp_id => " +
                tipo.datos![i].tpId.toString() +
                " tpnombre => " +
                tipo.datos![i].tpNombre.toString());
            DatosTpWs newTipo = DatosTpWs(
                tpId: tipo.datos![i].tpId,
                tpNombre: tipo.datos![i].tpNombre,
                tpNivel: tipo.datos![i].tpNivel,
                tpVigente: tipo.datos![i].tpVigente);
            await db.insertTipo(newTipo);
          }
        }
      }
    }
  }

  Future<Valores> cargarValores() async {
    Valores valores;
    Uri request = Uri.https(global.baseUrl, urls + "obtenerValores");
    final response = await client.post(request);
    String bodyByte = utf8.decode(response.bodyBytes);
    valores = Valores.fromJson(jsonDecode(bodyByte));
    if (valores.datos != null) {
      if (!valores.datos!.isEmpty) {
        if (valores.datos!.length > 0) {
          await db.eliminarValores();
          for (var i = 0; i < valores.datos!.length; i++) {
            print("Insert vl_id => " +
                valores.datos![i].vlTpId.toString() +
                " vl_id => " +
                valores.datos![i].vlId.toString() +
                " vl_nombre => " +
                valores.datos![i].vlNombre.toString());
            DatosVl newTipo = DatosVl(
                vlTpId: valores.datos![i].vlTpId,
                vlId: valores.datos![i].vlId,
                vlNombre: valores.datos![i].vlNombre,
                vlValor: valores.datos![i].vlValor,
                vlValor1: valores.datos![i].vlValor1,
                vlVigente: valores.datos![i].vlVigente);
            await db.insertValores(newTipo);
          }
        }
      }
    }
    return valores;
  }
}

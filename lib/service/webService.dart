import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as httpd;
import 'package:ms24hs/models/categoriaslist.dart';
import 'package:ms24hs/models/solictudes.dart';
import 'package:ms24hs/models/subCategorias.dart';
import 'package:ms24hs/models/categorias.dart';
import 'package:ms24hs/models/usuarios.dart';
import 'package:ms24hs/pagos.dart';
import 'package:ms24hs/servicios.dart';
import 'package:ms24hs/varglobal.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ms24hs/service/sharedPreferences.dart';
import 'package:ms24hs/db/dataBase.dart';
/** MODELOS */
import "package:ms24hs/models/usuario.dart";
import 'package:ms24hs/models/agenda.dart';
import 'package:ms24hs/models/tipo.dart';
import 'package:ms24hs/models/servicios.dart';
import 'package:ms24hs/models/valores.dart';
import 'package:ms24hs/models/UbicacionServicio.dart';
import 'package:ms24hs/models/pagos.dart';
import 'package:ms24hs/models/reservas.dart';

class WebService {
  final client = httpd.Client();
  final DB db = new DB();
  final prefs = SharedPreferences.getInstance();
  final urls = global.project + global.wsUrl + "ws/";

  Future<List<Categorias>> getCategory() async {
    print("Se llamo la funcion obtenerCategoriaLista");
    DB db = DB(); // Instancio la base de datos
    List<Categorias> data = [];
    data.add(Categorias(
        idCategoria: 0,
        nombreCategoria: "Seleccione una categorias",
        urlImagen: "",
        tipoCategoria: 0,
        vigente: ""));
    Uri url = Uri.https(
        global.baseUrl, global.project + global.wsUrl + "ws/categoria/obtener");
    await client.get(url, headers: {"Accept": "application/json"}).then(
        (respuesta) async {
      print("Entro aca");
      await db.eliminarCategoria();
      String body = utf8.decode(respuesta.bodyBytes);
      var datos = jsonDecode(body);
      for (var item in datos["categorias"]) {
        Categorias temp = Categorias(
            idCategoria: item["idCategoria"],
            nombreCategoria: item["nombreCategoria"],
            urlImagen: item["urlImagen"],
            tipoCategoria: item["tipoCategoria"],
            vigente: item["vigente"]);
        await db.insertCategoria(temp);
        data.add(temp);
      }
      return data;
    });

    return data;
  }

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
            print("Insert vl_tp_id => " +
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

  Future<int?> guardarAgenda(int? idDia, int? idDesde, int? idHasta) async {
    Datos? datosUsuario = global.datosUsuario;
    int? idUsuario = datosUsuario?.idUsuario;
    print("idUsuario ====> " + idUsuario.toString());
    Uri request = Uri.https(global.baseUrl, urls + "agenda/guardar", {
      "idUsuario": idUsuario.toString(),
      "idDia": idDia.toString(),
      "idDesde": idDesde.toString(),
      "idHasta": idHasta.toString(),
      "vigente": "S",
    });
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    print(response.body);
    print(response.statusCode);
    String bodyByte = utf8.decode(response.bodyBytes);
    Respuesta respuesta = Respuesta.fromJson(jsonDecode(bodyByte));
    print("Guardo agenda el codigo es ====>  " + respuesta.code.toString());
    return respuesta.code;
  }

  Future<ServiciosWs> obtenerServicios() async {
    print('Get Services');
    ServiciosWs servicio;
    Uri request = Uri.https(
      global.baseUrl,
      urls + "servicios/obtener",
    );
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    servicio = ServiciosWs.fromJson(jsonDecode(bodyByte));
    return servicio;
  }

  Future<List<SubCategorias>> getSubCategory(int idCategoria) async {
    print("Get sub category");
    List<SubCategorias> listSub = [];
    listSub.add(SubCategorias(
        subcatCatId: 0,
        subcatId: 0,
        subcatNombre: "Seleccione una sub categorias",
        subcatVigente: ""));
    Uri request = Uri.https(
      global.baseUrl,
      urls + "subCategoria/obtener",
      {"idCategoria": idCategoria.toString()},
    );
    final response =
        await client.get(request, headers: {"Accept": "application/json"});
    String body = utf8.decode(response.bodyBytes);
    var datos = jsonDecode(body);
    for (var item in datos) {
      listSub.add(SubCategorias(
          subcatId: item["subcat_id"],
          subcatCatId: item["subcat_cat_id"],
          subcatNombre: item["subcat_nombre"]));
    }
    return listSub;
  }

  Future<int> createService(
      File? imagen,
      String titulo,
      String contacto,
      String descripcion,
      int idCategoria,
      int idSubCategoria,
      int idPais) async {
    int resultado = -1;

    Uri request = Uri.https(
      global.baseUrl,
      urls + "servicios/crear",
    );

    var peticion = httpd.MultipartRequest("POST", request);
    peticion.fields["titulo"] = titulo;
    peticion.fields["contacto"] = contacto;
    peticion.fields["descripcion"] = descripcion;
    peticion.fields["categoria"] = idCategoria.toString();
    peticion.fields["subcategoria"] = idSubCategoria.toString();
    peticion.fields["pais"] = idPais.toString();
    peticion.fields["idusuario"] = global.datosUsuario!.idUsuario.toString();
    if (imagen!.path.isNotEmpty) {
      peticion.files
          .add(await httpd.MultipartFile.fromPath("imagen", imagen.path));
    }
    await peticion.send().then((value) async {
      await httpd.Response.fromStream(value).then((onValue) {
        if (onValue.statusCode == 200) //Esta todo OK
        {
          if (onValue.body == "S") {
            resultado = 1;
          } else {
            resultado = 500;
          }
        } else {
          resultado = onValue.statusCode;
        }
        return resultado;
      });
    });
    return resultado;
  }

  Future<UbicacionServicios> getLocationService(int idServicio) async {
    print('Get Location Services');
    print("Id del servicio de ubicacion " + idServicio.toString());
    UbicacionServicios servicio;
    Uri request = Uri.https(
      global.baseUrl,
      urls + "servicios/obtener/ubicacion",
      {"idServicio": idServicio.toString()},
    );
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    servicio = UbicacionServicios.fromJson(jsonDecode(bodyByte));
    return servicio;
  }

  Future<int?> agregarUbicacionServicio(
      int idServicio, String nombreLocalidad, String lat, String long) async {
    int? resultado = -1;
    print('Set Location Services');
    Uri request = Uri.https(
      global.baseUrl,
      urls + "servicios/obtener/ubicacion/agregar",
      {
        "idServicio": idServicio.toString(),
        "localidad": nombreLocalidad.toString(),
        "lat": lat.toString(),
        "long": long.toString(),
      },
    );
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    Respuesta respuesta = Respuesta.fromJson(jsonDecode(bodyByte));

    resultado = respuesta.code;

    return resultado;
  }

  Future<int?> eliminarUbicacionServicio(int idUbicacion) async {
    int? resultado = -1;
    print('Delete Location Services');
    Uri request = Uri.https(
      global.baseUrl,
      urls + "servicios/obtener/ubicacion/eliminar",
      {"idUbicacion": idUbicacion.toString()},
    );
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    Respuesta respuesta = Respuesta.fromJson(jsonDecode(bodyByte));

    resultado = respuesta.code!;

    return resultado;
  }

  Future<int?> eliminarServicio(int idServicio) async {
    int? resultado = -1;
    print('Delete Services');
    Uri request = Uri.https(
      global.baseUrl,
      urls + "servicios/eliminar",
      {"idServicio": idServicio.toString()},
    );
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    Respuesta respuesta = Respuesta.fromJson(jsonDecode(bodyByte));

    resultado = respuesta.code;

    return resultado;
  }

  Future<int?> actualizarServicio(
      int idServicio,
      String titulo,
      String contacto,
      String descripcion,
      int idCategoria,
      int idSubCategoria,
      int idPais) async {
    int? resultado = -1;
    print('Update Services');
    Uri request = Uri.https(
      global.baseUrl,
      urls + "servicios/actualizar",
      {
        "idServicio": idServicio.toString(),
        "titulo": titulo,
        "contacto": contacto,
        "descripcion": descripcion,
        "idCategoria": idCategoria.toString(),
        "idSubCategoria": idSubCategoria.toString(),
        "idPais": idPais.toString()
      },
    );
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    Respuesta respuesta = Respuesta.fromJson(jsonDecode(bodyByte));

    resultado = respuesta.code;

    return resultado;
  }

  Future<Datosservicios?> obtenerDatosServicio(int idServicio) async {
    print('Get Service (One only)');
    Uri request = Uri.https(
      global.baseUrl,
      urls + "servicio/obtener",
      {
        "idServicio": idServicio.toString(),
      },
    );
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    ServiciosWs respuesta = ServiciosWs.fromJson(jsonDecode(bodyByte));
    Datosservicios? datos = respuesta.datosservicios![0];
    return datos;
  }

  Future<PagosWs?> obtenerPagos() async {
    print('Get Pays');
    Uri request = Uri.https(
      global.baseUrl,
      urls + "pagos/obtener",
      {
        "idUsuario": global.datosUsuario!.idUsuario.toString(),
      },
    );
    final response =
        await client.get(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    PagosWs respuesta = PagosWs.fromJson(jsonDecode(bodyByte));
    return respuesta;
  }

  Future<ReservasWs> obtenerReservas() async {
    print('Obtener reservas');
    Uri request = Uri.https(
      global.baseUrl,
      urls + "reservas/obtener",
      {
        "idUsuario": global.datosUsuario!.idUsuario.toString(),
        "idTipoUsuario": global.datosUsuario!.tipoUsuario.toString()
      },
    );
    final response =
        await client.get(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    ReservasWs respuesta = ReservasWs.fromJson(jsonDecode(bodyByte));
    return respuesta;
  }

  Future<Valores?> obtenerPaises() async {
    print('Obtener paises');
    Uri request = Uri.https(
      global.baseUrl,
      urls + "obtenerpaises",
    );
    final response =
        await client.post(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    Valores? respuesta = Valores.fromJson(jsonDecode(bodyByte));
    return respuesta;
  }

  Future<Usuarios?> obtenerUsuarios() async {
    print('Obtener usuarios');
    Uri request = Uri.https(
      global.baseUrl,
      urls + "sistema/usuario/obtener",
    );
    final response =
        await client.get(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    Usuarios? respuesta = Usuarios.fromJson(jsonDecode(bodyByte));
    return respuesta;
  }

  Future<Solicitudes?> obtenerSolicitudes() async {
    print('Obtener solicitudes');
    Uri request = Uri.https(
      global.baseUrl,
      urls + "sistema/solicitud/obtener",
    );
    final response =
        await client.get(request, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(response.bodyBytes);
    Solicitudes? respuesta = Solicitudes.fromJson(jsonDecode(bodyByte));
    return respuesta;
  }

  Future<CategoriaList> obtenerCategoriasLista() async {
    Uri url = Uri.https(global.baseUrl, urls + "categoria/obtenerlist");
    final respuesta =
        await client.get(url, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(respuesta.bodyBytes);
    CategoriaList data = CategoriaList.fromJson(jsonDecode(bodyByte));
    return data;
  }

  Future<Respuesta> registroUsuario(
      String prof,
      int idCategoria,
      int idSubCategoria,
      String nombre,
      String apellido,
      String correo,
      String clave,
      String contacto) async {
    print(prof);
    Uri url = Uri.https(
      global.baseUrl,
      urls + "usuario/registro",
      {
        "esProf": prof.toString(),
        "idCategoria": idCategoria.toString(),
        "idSubCategoria": idSubCategoria.toString(),
        "nombre": nombre.toString(),
        "apellido": apellido.toString(),
        "correo": correo.toString(),
        "clave": clave.toString(),
        "contacto": contacto.toString(),
      },
    );
    final respuesta =
        await client.post(url, headers: {"Accept": "application/json"});
    String bodyByte = utf8.decode(respuesta.bodyBytes);
    Respuesta data = Respuesta.fromJson(jsonDecode(bodyByte));
    return data;
  }

  Future<Respuesta> generarReserva(String idServicio, String dia, String hora,
      String lugar, String lat, String long, String descripcion) async {
    Uri url = Uri.https(
      global.baseUrl,
      urls + "reservas/generar",
      {
        "idUsuario": global.datosUsuario!.idUsuario.toString(),
        "idServicio": idServicio.toString(),
        "fecha": dia.toString(),
        "hora": hora.toString(),
        "localidad": lugar.toString(),
        "lat": lat.toString(),
        "long": long.toString(),
        "descripcion": descripcion.toString()
      },
    );
    final respuesta =
        await client.post(url, headers: {"Accept": "application/json"});
    print(respuesta.body);
    String bodyByte = utf8.decode(respuesta.bodyBytes);
    Respuesta data = Respuesta.fromJson(jsonDecode(bodyByte));
    return data;
  }
}

class Respuesta {
  int? code;
  String? respuesta;

  Respuesta({required this.code, required this.respuesta});

  Respuesta.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    respuesta = json['respuesta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['respuesta'] = this.respuesta;
    return data;
  }
}

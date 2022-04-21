library ms24hs.global;

import 'package:flutter/material.dart';
import 'models/usuario.dart';

/** BASE URL */
String baseUrl = "ms24hs.com";
String project = "/desa"; //Desa
//String project = "/prod"; //Prod

/** URL  WS */
String wsUrl = "/public/";

/** URL Image */
String imgUrl = "/storage/app/";

/** Version APP */
var vApp = "1.0";
var vAppWeb = "1.0";
var usaWs = "S";

/** Colores */
Color fondoGris = Color.fromARGB(72, 222, 217, 217);
Color colorFondo = Color.fromARGB(255, 253, 216, 53);

/** API KEY */
String googleKey = "AIzaSyCSRyd6_fhcAKO0-WocoGv_G7Wq0AJxBCc";

String latMovil = "";
String longMovil = "";

/** DATOS DEL USUARIO */
bool logeado = false;
Datos? datosUsuario;

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ms24hs/models/UbicacionServicio.dart';
import 'package:ms24hs/service/webService.dart';
import '../varglobal.dart' as global;
import 'package:ms24hs/models/servicios.dart';
import 'package:ms24hs/servicios/agregar_ubicacion.dart';
import 'package:ms24hs/provider/pantallaCarga.dart';
import 'package:ms24hs/buscador.dart';

class ServicioEstruc {
  final GlobalKey _ModalCarga = new GlobalKey();
  Widget mostrarServicio(BuildContext context, String urlImagen,
      String nombreServicio, String descripcionServicio, int idServicio) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white70, width: 10.0),
                    // ignore: prefer_const_constructors
                    borderRadius: BorderRadius.all(
                      const Radius.circular(32.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[700]!,
                        offset: const Offset(-8, 8),
                        blurRadius: 10,
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.network(
                        'https://' +
                            global.baseUrl +
                            global.project +
                            global.imgUrl +
                            urlImagen.toString(),
                        scale: 0.8,
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.width / 1.5,
                        alignment: Alignment.center,
                      ),
                    ), //Imagen del servicio
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(
                              nombreServicio.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(padding: EdgeInsets.only(top: 6)),
                            Text(
                              descripcionServicio.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ), //Titulo y descripcion del servicio
                    if (global.logeado) ...[
                      RaisedButton(
                        onPressed: () {
                          abrirModalReserva(context);
                        },
                        padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          child: const Text(
                            "Reservar",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        color: const Color.fromARGB(255, 53, 126, 235),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void abrirModalReserva(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Text("Acca"),
          );
        });
  }
}

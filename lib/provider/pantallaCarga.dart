import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PantallaCarga {
  static Future<void> cargandoDatos(
      BuildContext context, GlobalKey _key, String? mensaje) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: Dialog(
              key: _key,
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              child: Wrap(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text("Cargando datos...",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  const Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

library ms24hs.splash;

import 'package:flutter/material.dart';

class Splash {
  Widget splash(BuildContext context) {
    Widget splashW = Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      color: Colors.yellow[600],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/img/logo-sos.png",
              // width: MediaQuery.of(context).size.width / 2,
              height: 200,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Cargando..",
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          Center(child: CircularProgressIndicator())
        ],
      ),
    );
    return splashW;
  }
}

class PagosWs {
  List<DatosPagos>? datosPagos;

  PagosWs({this.datosPagos});

  PagosWs.fromJson(Map<String, dynamic> json) {
    if (json['datosPagos'] != null) {
      datosPagos = <DatosPagos>[];
      json['datosPagos'].forEach((v) {
        datosPagos!.add(new DatosPagos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datosPagos != null) {
      data['datosPagos'] = this.datosPagos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DatosPagos {
  String? servicio;
  String? nombreCliente;
  String? fecha;
  String? medioPago;
  String? opcionPago;
  String? monto;
  String? estado;

  DatosPagos(
      {this.servicio,
      this.nombreCliente,
      this.fecha,
      this.medioPago,
      this.opcionPago,
      this.monto,
      this.estado});

  DatosPagos.fromJson(Map<String, dynamic> json) {
    servicio = json['servicio'];
    nombreCliente = json['nombreCliente'];
    fecha = json['fecha'];
    medioPago = json['medioPago'];
    opcionPago = json['opcionPago'];
    monto = json['monto'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['servicio'] = this.servicio;
    data['nombreCliente'] = this.nombreCliente;
    data['fecha'] = this.fecha;
    data['medioPago'] = this.medioPago;
    data['opcionPago'] = this.opcionPago;
    data['monto'] = this.monto;
    data['estado'] = this.estado;
    return data;
  }
}

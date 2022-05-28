class ReservasWs {
  List<DatosR>? datos;

  ReservasWs({this.datos});

  ReservasWs.fromJson(Map<String, dynamic> json) {
    if (json['datos'] != null) {
      datos = <DatosR>[];
      json['datos'].forEach((v) {
        datos!.add(new DatosR.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datos != null) {
      data['datos'] = this.datos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DatosR {
  int? idReserva;
  String? fechaReserva;
  String? horaReserva;
  String? observacionReserva;
  String? nombreCliente;
  int? idServicio;
  String? nombreServicio;
  String? estado;
  String? estadoId;

  DatosR(
      {this.idReserva,
      this.fechaReserva,
      this.horaReserva,
      this.observacionReserva,
      this.nombreCliente,
      this.idServicio,
      this.nombreServicio,
      this.estado,
      this.estadoId});

  DatosR.fromJson(Map<String, dynamic> json) {
    idReserva = json['idReserva'];
    fechaReserva = json['fechaReserva'];
    horaReserva = json['horaReserva'];
    observacionReserva = json['observacionReserva'];
    nombreCliente = json['nombreCliente'];
    idServicio = json['idServicio'];
    nombreServicio = json['nombreServicio'];
    estado = json['estado'];
    estadoId = json['estadoId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idReserva'] = this.idReserva;
    data['fechaReserva'] = this.fechaReserva;
    data['horaReserva'] = this.horaReserva;
    data['observacionReserva'] = this.observacionReserva;
    data['nombreCliente'] = this.nombreCliente;
    data['idServicio'] = this.idServicio;
    data['nombreServicio'] = this.nombreServicio;
    data['estado'] = this.estado;
    data['estadoId'] = this.estadoId;
    return data;
  }
}

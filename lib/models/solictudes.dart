class Solicitudes {
  List<Listasol>? listasol;

  Solicitudes({this.listasol});

  Solicitudes.fromJson(Map<String, dynamic> json) {
    if (json['listasol'] != null) {
      listasol = <Listasol>[];
      json['listasol'].forEach((v) {
        listasol!.add(new Listasol.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listasol != null) {
      data['listasol'] = this.listasol!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Listasol {
  int? idUsuario;
  String? nombreUsuario;
  int? idSolicitud;
  String? estado;
  String? fechaSolicitado;
  String? nombreCategoria;

  Listasol(
      {this.idUsuario,
      this.nombreUsuario,
      this.idSolicitud,
      this.estado,
      this.fechaSolicitado,
      this.nombreCategoria});

  Listasol.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    nombreUsuario = json['nombreUsuario'];
    idSolicitud = json['idSolicitud'];
    estado = json['estado'];
    fechaSolicitado = json['fechaSolicitado'];
    nombreCategoria = json['nombreCategoria'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUsuario'] = this.idUsuario;
    data['nombreUsuario'] = this.nombreUsuario;
    data['idSolicitud'] = this.idSolicitud;
    data['estado'] = this.estado;
    data['fechaSolicitado'] = this.fechaSolicitado;
    data['nombreCategoria'] = this.nombreCategoria;
    return data;
  }
}

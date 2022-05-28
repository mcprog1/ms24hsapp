class Usuarios {
  List<Listusuario>? listusuario;

  Usuarios({this.listusuario});

  Usuarios.fromJson(Map<String, dynamic> json) {
    if (json['listusuario'] != null) {
      listusuario = <Listusuario>[];
      json['listusuario'].forEach((v) {
        listusuario!.add(new Listusuario.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listusuario != null) {
      data['listusuario'] = this.listusuario!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Listusuario {
  int? idUsuario;
  String? nombreUsuario;
  String? tipoUsuario;
  int? tipoUsuarioId;
  String? categoria;
  String? ultimoIngreso;
  String? estado;
  String? estadoL;

  Listusuario(
      {this.idUsuario,
      this.nombreUsuario,
      this.tipoUsuario,
      this.tipoUsuarioId,
      this.categoria,
      this.ultimoIngreso,
      this.estado,
      this.estadoL});

  Listusuario.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    nombreUsuario = json['nombreUsuario'];
    tipoUsuario = json['tipoUsuario'];
    tipoUsuarioId = json['tipoUsuarioId'];
    categoria = json['categoria'];
    ultimoIngreso = json['ultimoIngreso'];
    estado = json['estado'];
    estadoL = json['estadoL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUsuario'] = this.idUsuario;
    data['nombreUsuario'] = this.nombreUsuario;
    data['tipoUsuario'] = this.tipoUsuario;
    data['tipoUsuarioId'] = this.tipoUsuarioId;
    data['categoria'] = this.categoria;
    data['ultimoIngreso'] = this.ultimoIngreso;
    data['estado'] = this.estado;
    data['estadoL'] = this.estadoL;
    return data;
  }
}

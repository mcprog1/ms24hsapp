class Usuario {
  int? codigo;
  String? mensaje;
  Datos? datos;

  Usuario({this.codigo, this.mensaje, this.datos});

  Usuario.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    mensaje = json['mensaje'];
    datos = json['datos'] != null ? new Datos.fromJson(json['datos']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['mensaje'] = this.mensaje;
    if (this.datos != null) {
      data['datos'] = this.datos!.toJson();
    }
    return data;
  }
}

class Datos {
  int? idUsuario;
  String? nombre;
  String? correo;
  int? tipoUsuario;
  String? nivelUsuario;

  Datos(
      {this.idUsuario,
      this.nombre,
      this.correo,
      this.tipoUsuario,
      this.nivelUsuario});

  Datos.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    nombre = json['nombre'];
    correo = json['correo'];
    tipoUsuario = json['tipoUsuario'];
    nivelUsuario = json['nivelUsuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUsuario'] = this.idUsuario;
    data['nombre'] = this.nombre;
    data['correo'] = this.correo;
    data['tipoUsuario'] = this.tipoUsuario;
    data['nivelUsuario'] = this.nivelUsuario;
    return data;
  }
}

class ServiciosWs {
  List<Datosservicios>? datosservicios;

  ServiciosWs({this.datosservicios});

  ServiciosWs.fromJson(Map<String, dynamic> json) {
    if (json['datosservicios'] != null) {
      datosservicios = <Datosservicios>[];
      json['datosservicios'].forEach((v) {
        datosservicios!.add(new Datosservicios.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datosservicios != null) {
      data['datosservicios'] =
          this.datosservicios!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datosservicios {
  int? id;
  String? nombre;
  String? localidad;
  String? numeroTelefono;
  String? categoria;
  String? subCategoria;
  String? urlImagen;
  String? descripcionServicio;

  Datosservicios(
      {this.id,
      this.nombre,
      this.localidad,
      this.numeroTelefono,
      this.categoria,
      this.subCategoria,
      this.urlImagen,
      this.descripcionServicio});

  Datosservicios.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    localidad = json['localidad'];
    numeroTelefono = json['numeroTelefono'];
    categoria = json['categoria'];
    subCategoria = json['subCategoria'];
    urlImagen = json['urlImagen'];
    descripcionServicio = json['descripcionServicio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['localidad'] = this.localidad;
    data['numeroTelefono'] = this.numeroTelefono;
    data['categoria'] = this.categoria;
    data['subCategoria'] = this.subCategoria;
    data['urlImagen'] = this.urlImagen;
    data['descripcionServicio'] = this.descripcionServicio;
    return data;
  }
}

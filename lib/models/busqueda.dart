class Busqueda {
  int? codigo;
  List<DatosBusqueda>? datosBusqueda;

  Busqueda({this.codigo, this.datosBusqueda});

  Busqueda.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    if (json['datosBusqueda'] != null) {
      datosBusqueda = <DatosBusqueda>[];
      json['datosBusqueda'].forEach((v) {
        datosBusqueda!.add(new DatosBusqueda.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    if (this.datosBusqueda != null) {
      data['datosBusqueda'] =
          this.datosBusqueda!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DatosBusqueda {
  int? idServicio;
  String? nombreServicio;
  String? descripcionServicio;
  String? categoriaNombre;
  String? localidadNombre;
  String? servicioLat;
  String? servicioLong;
  String? nombreProfesional;
  String? urlImagen;
  String? contacto;

  DatosBusqueda(
      {this.idServicio,
      this.nombreServicio,
      this.descripcionServicio,
      this.categoriaNombre,
      this.localidadNombre,
      this.servicioLat,
      this.servicioLong,
      this.nombreProfesional,
      this.urlImagen,
      this.contacto});

  DatosBusqueda.fromJson(Map<String, dynamic> json) {
    idServicio = json['idServicio'];
    nombreServicio = json['nombreServicio'];
    descripcionServicio = json['descripcionServicio'];
    categoriaNombre = json['categoriaNombre'];
    localidadNombre = json['localidadNombre'];
    servicioLat = json['servicioLat'];
    servicioLong = json['servicioLong'];
    nombreProfesional = json['nombreProfesional'];
    urlImagen = json['urlImagen'];
    contacto = json['contacto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idServicio'] = this.idServicio;
    data['nombreServicio'] = this.nombreServicio;
    data['descripcionServicio'] = this.descripcionServicio;
    data['categoriaNombre'] = this.categoriaNombre;
    data['localidadNombre'] = this.localidadNombre;
    data['servicioLat'] = this.servicioLat;
    data['servicioLong'] = this.servicioLong;
    data['nombreProfesional'] = this.nombreProfesional;
    data['urlImagen'] = this.urlImagen;
    data['contacto'] = this.contacto;
    return data;
  }
}

class UbicacionServicios {
  List<Data>? data;
  String? code;

  UbicacionServicios({this.data, this.code});

  UbicacionServicios.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    return data;
  }
}

class Data {
  int? idubicacion;
  int? idservicio;
  String? lat;
  String? long;
  String? localidad;

  Data(
      {this.idubicacion, this.idservicio, this.lat, this.long, this.localidad});

  Data.fromJson(Map<String, dynamic> json) {
    idubicacion = json['idubicacion'];
    idservicio = json['idservicio'];
    lat = json['lat'];
    long = json['long'];
    localidad = json['localidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idubicacion'] = this.idubicacion;
    data['idservicio'] = this.idservicio;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['localidad'] = this.localidad;
    return data;
  }
}

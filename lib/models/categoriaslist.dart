class CategoriaList {
  List<Listcat>? listcat;

  CategoriaList({this.listcat});

  CategoriaList.fromJson(Map<String, dynamic> json) {
    if (json['listcat'] != null) {
      listcat = <Listcat>[];
      json['listcat'].forEach((v) {
        listcat!.add(new Listcat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listcat != null) {
      data['listcat'] = this.listcat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Listcat {
  int? idCategoria;
  String? nombreCategoria;
  String? urlImagen;
  int? tipoCategoria;
  String? vigente;

  Listcat(
      {this.idCategoria,
      this.nombreCategoria,
      this.urlImagen,
      this.tipoCategoria,
      this.vigente});

  Listcat.fromJson(Map<String, dynamic> json) {
    idCategoria = json['idCategoria'];
    nombreCategoria = json['nombreCategoria'];
    urlImagen = json['urlImagen'];
    tipoCategoria = json['tipoCategoria'];
    vigente = json['vigente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idCategoria'] = this.idCategoria;
    data['nombreCategoria'] = this.nombreCategoria;
    data['urlImagen'] = this.urlImagen;
    data['tipoCategoria'] = this.tipoCategoria;
    data['vigente'] = this.vigente;
    return data;
  }
}

class Categorias {
  late int idCategoria;
  late String nombreCategoria;
  late String urlImagen;
  late int tipoCategoria;
  late String vigente;

  Categorias(
      {required this.idCategoria,
      required this.nombreCategoria,
      required this.urlImagen,
      required this.tipoCategoria,
      required this.vigente});

  Categorias.fromJson(Map<String, dynamic> json) {
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

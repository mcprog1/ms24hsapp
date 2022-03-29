class Categorias {
  int idCategoria;
  String nombreCategoria;
  String urlImagen;
  int tipoCategoria;
  String vigente;

  Categorias(
      {required this.idCategoria,
      required this.nombreCategoria,
      required this.urlImagen,
      required this.tipoCategoria,
      required this.vigente});

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

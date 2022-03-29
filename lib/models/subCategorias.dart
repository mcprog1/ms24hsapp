class SubCategorias {
  int subcatId;
  int subcatCatId;
  String subcatNombre;
  String? subcatVigente;

  SubCategorias(
      {required this.subcatId,
      required this.subcatCatId,
      required this.subcatNombre,
      this.subcatVigente});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcat_id'] = this.subcatId;
    data['subcat_cat_id'] = this.subcatCatId;
    data['subcat_nombre'] = this.subcatNombre;
    data['subcat_vigente'] = this.subcatVigente;
    return data;
  }
}

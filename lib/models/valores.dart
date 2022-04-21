class Valores {
  int? tpId;
  String? tpNombre;
  int? tpNivel;
  String? tpVigente;

  Valores({this.tpId, this.tpNombre, this.tpNivel, this.tpVigente});

  Valores.fromJson(Map<String, dynamic> json) {
    tpId = json['tp_id'];
    tpNombre = json['tp_nombre'];
    tpNivel = json['tp_nivel'];
    tpVigente = json['tp_vigente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tp_id'] = this.tpId;
    data['tp_nombre'] = this.tpNombre;
    data['tp_nivel'] = this.tpNivel;
    data['tp_vigente'] = this.tpVigente;
    return data;
  }
}

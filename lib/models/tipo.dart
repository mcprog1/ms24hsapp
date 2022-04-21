class Tipo {
  List<DatosTpWs>? datos;

  Tipo({this.datos});

  Tipo.fromJson(Map<String, dynamic> json) {
    if (json['datos'] != null) {
      datos = <DatosTpWs>[];
      json['datos'].forEach((v) {
        datos!.add(new DatosTpWs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datos != null) {
      data['datos'] = this.datos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DatosTpWs {
  int? tpId;
  String? tpNombre;
  int? tpNivel;
  String? tpVigente;

  DatosTpWs({this.tpId, this.tpNombre, this.tpNivel, this.tpVigente});

  DatosTpWs.fromJson(Map<String, dynamic> json) {
    tpId = json['tp_id'];
    tpNombre = json['tp_nombre'];
    tpNivel = json['tp_nivel'];
    tpVigente = json['tp_vigente'];
  }

  Map<String, dynamic> toMap() {
    return {
      "tp_id": tpId,
      "tp_nombre": tpNombre,
      "tp_nivel": tpNivel,
      "tp_vigente": tpVigente
    };
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

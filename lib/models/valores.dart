class Valores {
  List<DatosVl>? datos;

  Valores({this.datos});

  Valores.fromJson(Map<String, dynamic> json) {
    if (json['datos'] != null) {
      datos = <DatosVl>[];
      json['datos'].forEach((v) {
        datos!.add(new DatosVl.fromJson(v));
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

class DatosVl {
  int? vlId;
  int? vlTpId;
  String? vlNombre;
  String? vlValor;
  String? vlValor1;
  String? vlVigente;

  DatosVl(
      {this.vlId,
      this.vlTpId,
      this.vlNombre,
      this.vlValor,
      this.vlValor1,
      this.vlVigente});

  DatosVl.fromJson(Map<String, dynamic> json) {
    vlId = json['vl_id'];
    vlTpId = json['vl_tp_id'];
    vlNombre = json['vl_nombre'];
    vlValor = json['vl_valor'];
    vlValor1 = json['vl_valor1'];
    vlVigente = json['vl_vigente'];
  }

  Map<String, dynamic> toMap() {
    return {
      "vl_tp_id": vlTpId,
      "vl_id": vlId,
      "vl_nombre": vlNombre,
      "vl_valor": vlValor,
      "vl_valor1": vlValor1,
      "tp_vigente": vlVigente
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vl_id'] = this.vlId;
    data['vl_tp_id'] = this.vlTpId;
    data['vl_nombre'] = this.vlNombre;
    data['vl_valor'] = this.vlValor;
    data['vl_valor1'] = this.vlValor1;
    data['vl_vigente'] = this.vlVigente;
    return data;
  }
}

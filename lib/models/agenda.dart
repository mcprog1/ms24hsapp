class AgendaWs {
  List<DatosAgenda>? datosAgenda;

  AgendaWs({this.datosAgenda});

  AgendaWs.fromJson(Map<String, dynamic> json) {
    if (json['datosAgenda'] != null) {
      datosAgenda = <DatosAgenda>[];
      json['datosAgenda'].forEach((v) {
        datosAgenda!.add(new DatosAgenda.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datosAgenda != null) {
      data['datosAgenda'] = this.datosAgenda!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DatosAgenda {
  int? idAgenda;
  int? iDia;
  String? dia;
  int? idDesde;
  String? desde;
  int? idHasta;
  String? hasta;
  String? vigente;

  DatosAgenda(
      {this.idAgenda,
      this.iDia,
      this.dia,
      this.idDesde,
      this.desde,
      this.idHasta,
      this.hasta,
      this.vigente});

  DatosAgenda.fromJson(Map<String, dynamic> json) {
    idAgenda = json['idAgenda'];
    iDia = json['iDia'];
    dia = json['dia'];
    idDesde = json['idDesde'];
    desde = json['desde'];
    idHasta = json['idHasta'];
    hasta = json['hasta'];
    vigente = json['vigente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idAgenda'] = this.idAgenda;
    data['iDia'] = this.iDia;
    data['dia'] = this.dia;
    data['idDesde'] = this.idDesde;
    data['desde'] = this.desde;
    data['idHasta'] = this.idHasta;
    data['hasta'] = this.hasta;
    data['vigente'] = this.vigente;
    return data;
  }
}

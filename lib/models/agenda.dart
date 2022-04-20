class AgendaWs {
  int? idAgenda;
  int? iDia;
  String? dia;
  int? idDesde;
  String? desde;
  int? idHasta;
  String? hasta;
  String? vigente;

  AgendaWs(
      {this.idAgenda,
      this.iDia,
      this.dia,
      this.idDesde,
      this.desde,
      this.idHasta,
      this.hasta,
      this.vigente});

  AgendaWs.fromJson(Map<String, dynamic> json) {
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

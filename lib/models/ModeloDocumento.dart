class ModeloDocumento {
  List<DatosDocumento> data;

  ModeloDocumento({this.data});

  ModeloDocumento.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<DatosDocumento>();
      json['data'].forEach((v) {
        data.add(new DatosDocumento.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DatosDocumento {
  String idDocumento;
  String tipoDocumento;

  DatosDocumento({this.idDocumento, this.tipoDocumento});

  DatosDocumento.fromJson(Map<String, dynamic> json) {
    idDocumento = json['idDocumento'];
    tipoDocumento = json['tipoDocumento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idDocumento'] = this.idDocumento;
    data['tipoDocumento'] = this.tipoDocumento;
    return data;
  }
}
class ModeloRespuestaLogin {
  bool hasData;
  Session session;

  ModeloRespuestaLogin({this.hasData, this.session});

  ModeloRespuestaLogin.fromJson(Map<String, dynamic> json) {
    hasData = json['hasData'];
    session =
        json['session'] != null ? new Session.fromJson(json['session']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasData'] = this.hasData;
    if (this.session != null) {
      data['session'] = this.session.toJson();
    }
    return data;
  }
}

class Session {
  String idUsuario;
  String nombre;
  String correo;
  String clave;
  String tipoDocumento;
  String numeroDocumento;

  Session(
      {this.idUsuario,
      this.nombre,
      this.correo,
      this.clave,
      this.tipoDocumento,
      this.numeroDocumento});

  Session.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    nombre = json['nombre'];
    correo = json['correo'];
    clave = json['clave'];
    tipoDocumento = json['tipoDocumento'];
    numeroDocumento = json['numeroDocumento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUsuario'] = this.idUsuario;
    data['nombre'] = this.nombre;
    data['correo'] = this.correo;
    data['clave'] = this.clave;
    data['tipoDocumento'] = this.tipoDocumento;
    data['numeroDocumento'] = this.numeroDocumento;
    return data;
  }
}
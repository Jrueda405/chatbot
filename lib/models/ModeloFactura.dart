class ModeloFactura {
  bool hasData;
  List<Facturas> facturas;

  ModeloFactura({this.hasData, this.facturas});

  ModeloFactura.fromJson(Map<String, dynamic> json) {
    hasData = json['hasData'];
    if (json['facturas'] != null) {
      facturas = new List<Facturas>();
      json['facturas'].forEach((v) {
        facturas.add(new Facturas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasData'] = this.hasData;
    if (this.facturas != null) {
      data['facturas'] = this.facturas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Facturas {
  String factura;
  String fecha;
  String valor;
  String descripcion;
  String estado;
  String fechapago;

  Facturas(
      {this.factura,
      this.fecha,
      this.valor,
      this.descripcion,
      this.estado,
      this.fechapago});

  Facturas.fromJson(Map<String, dynamic> json) {
    factura = json['factura'];
    fecha = json['fecha'];
    valor = json['valor'];
    descripcion = json['descripcion'];
    estado = json['estado'];
    fechapago = json['fechapago'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['factura'] = this.factura;
    data['fecha'] = this.fecha;
    data['valor'] = this.valor;
    data['descripcion'] = this.descripcion;
    data['estado'] = this.estado;
    data['fechapago'] = this.fechapago;
    return data;
  }
}
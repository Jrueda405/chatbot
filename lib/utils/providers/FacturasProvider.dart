import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FacturasProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _fechaInicio;
  String _fechaFin;
  String _numeroFactura;

  String get fechaInicio => _fechaInicio;
  String get fechaFin => _fechaFin;
  String get numeroFactura => _numeroFactura;

  void asignarNumeroFactura(String nuevoNumero) {
    _numeroFactura = nuevoNumero;
    _fechaInicio = null;
    _fechaFin = null;
    notifyListeners();
  }

  void asignarFechaInicio(String nuevoValor) {
    _numeroFactura = null;
    _fechaInicio = nuevoValor;
    notifyListeners();
  }

  void asignarFechaFin(String nuevoValor) {
    _numeroFactura = null;
    _fechaFin = nuevoValor;
    notifyListeners();
  }


  void limpiarBusquedaFacturas() {
    _numeroFactura = null;
    _fechaInicio = null;
    _fechaFin = null;
  }
}
